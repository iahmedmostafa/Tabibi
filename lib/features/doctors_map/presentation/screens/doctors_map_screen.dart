import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/services/location_services.dart';
import 'package:tabibi/features/doctors_map/data/models/doctor_map_model.dart';
import 'package:tabibi/features/doctors_map/presentation/controller/doctor_map_cubit.dart';
import 'package:tabibi/features/doctors_map/presentation/controller/doctor_map_state.dart';
import 'package:tabibi/features/doctors_map/presentation/widgets/doctor_details_card.dart';
import 'package:tabibi/features/doctors_map/presentation/widgets/my_location_button.dart';

class DoctorsMapScreen extends StatefulWidget {
  const DoctorsMapScreen({super.key});

  @override
  State<DoctorsMapScreen> createState() => _DoctorsMapScreenState();
}

class _DoctorsMapScreenState extends State<DoctorsMapScreen> {
  GoogleMapController? _mapController;
  final LocationServices _locationServices = LocationServices();
  late DoctorMapCubit _cubit;
  Set<Marker> _markers = {};
  DoctorMapModel? _selectedDoctor;
  bool _isFirstLoad = true;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(30.0444, 31.2357), // Cairo, Egypt
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _cubit = sl<DoctorMapCubit>();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _cubit.close();
    super.dispose();
  }

  final Map<String, BitmapDescriptor> _customMarkersCache = {};

  Future<void> _loadMarkers(List<DoctorMapModel> doctors) async {
    if (doctors.isEmpty) {
      if (mounted) {
        setState(() {
          _markers = {};
        });
      }
      return;
    }

    final List<Marker> markers = await Future.wait(
      doctors.map((doctor) async {
        BitmapDescriptor icon;

        if (_customMarkersCache.containsKey(doctor.id)) {
          icon = _customMarkersCache[doctor.id]!;
        } else {
          try {
            final Uint8List markerIconBytes = await _locationServices
                .getDoctorMarker(
                  markerPath: 'assets/images/marker.png',
                  imageUrl: doctor.avatarUrl,
                  size: 50, // Adjusted size for better visibility
                );
            icon = BitmapDescriptor.bytes(markerIconBytes);
            _customMarkersCache[doctor.id] = icon;
          } catch (e) {
            log('Error generating custom marker for doctor ${doctor.name}: $e');
            icon = BitmapDescriptor.defaultMarker;
          }
        }

        return Marker(
          markerId: MarkerId(doctor.id),
          icon: icon,
          position: LatLng(doctor.latitude, doctor.longitude),
          onTap: () {
            setState(() {
              _selectedDoctor = doctor;
            });
          },
          infoWindow: InfoWindow(
            title: doctor.name,
            snippet: doctor.department,
          ),
        );
      }),
    );

    if (mounted) {
      setState(() {
        _markers = markers.toSet();
      });
    }

    if (_isFirstLoad && doctors.isNotEmpty && _mapController != null) {
      _isFirstLoad = false;
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(doctors.first.latitude, doctors.first.longitude),
          12,
        ),
      );
    }
  }

  Future<void> _refreshDoctors() async {
    if (_mapController == null) return;

    final LatLngBounds bounds = await _mapController!.getVisibleRegion();
    if (!mounted) return;

    _cubit.getDoctorsOnMap(
      minLat: bounds.southwest.latitude,
      maxLat: bounds.northeast.latitude,
      minLng: bounds.southwest.longitude,
      maxLng: bounds.northeast.longitude,
    );
  }

  Future<void> _goToMyLocation() async {
    try {
      final LocationData locationData = await _locationServices.getLocation();
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(locationData.latitude!, locationData.longitude!),
          14,
        ),
      );
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('myLocation'),
            position: LatLng(locationData.latitude!, locationData.longitude!),
          ),
        );
      });
    } catch (e) {
      // Handle location error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get your location')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: BlocConsumer<DoctorMapCubit, DoctorMapState>(
          listener: (context, state) {
            if (state is DoctorMapSuccess) {
              _loadMarkers(state.doctors);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _initialPosition,
                  markers: _markers,
                  zoomControlsEnabled: true,
                  mapToolbarEnabled: true,
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _refreshDoctors();
                  },
                  onCameraIdle: _refreshDoctors,
                  onTap: (_) {
                    setState(() {
                      _selectedDoctor = null;
                    });
                  },
                ),

                MyLocationButton(
                  onPressed: _goToMyLocation,
                  bottomOffset: _selectedDoctor != null ? 200.h : 24.h,
                ),
                if (_selectedDoctor != null)
                  DoctorDetailsCard(
                    doctor: _selectedDoctor!,
                    onClose: () {
                      setState(() {
                        _selectedDoctor = null;
                      });
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
