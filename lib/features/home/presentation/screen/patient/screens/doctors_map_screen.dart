import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tabibi/core/services/location_services.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/doctors_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/doctors_state.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/custom_text_field.dart';

class DoctorsMapScreen extends StatefulWidget {
  const DoctorsMapScreen({super.key});

  @override
  State<DoctorsMapScreen> createState() => _DoctorsMapScreenState();
}

class _DoctorsMapScreenState extends State<DoctorsMapScreen> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final LocationServices _locationServices = LocationServices();
  Set<Marker> _markers = {};
  DoctorModel? _selectedDoctor;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(30.0444, 31.2357), // Cairo, Egypt
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMarkers();
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadMarkers() {
    final state = context.read<DoctorsCubit>().state;
    final doctors = state.doctors.where((doctor) {
      return doctor.latitude != null && doctor.longitude != null;
    }).toList();

    if (doctors.isEmpty) return;

    final markers = <Marker>{};

    for (final doctor in doctors) {
      markers.add(
        Marker(
          markerId: MarkerId(doctor.id),
          position: LatLng(doctor.latitude!, doctor.longitude!),
          onTap: () {
            setState(() {
              _selectedDoctor = doctor;
            });
          },
          infoWindow: InfoWindow(
            title: doctor.name,
            snippet: doctor.department,
          ),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });

    // Animate to first doctor location
    if (doctors.isNotEmpty && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(doctors.first.latitude!, doctors.first.longitude!),
          12,
        ),
      );
    }
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
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: BlocConsumer<DoctorsCubit, DoctorsState>(
        listener: (context, state) {
          if (state.status == DoctorsStatus.success) {
            _loadMarkers();
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: _initialPosition,
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                onTap: (_) {
                  setState(() {
                    _selectedDoctor = null;
                  });
                },
              ),
              _MapSearchBar(
                controller: _searchController,
                onSearch: (query) {
                  context.read<DoctorsCubit>().getDoctors(query: query);
                },
              ),
              _MyLocationButton(
                onPressed: _goToMyLocation,
                bottomOffset: _selectedDoctor != null ? 220.h : 24.h,
              ),
              // if (_selectedDoctor != null)
              //   _DoctorDetailsCard(
              //     doctor: _selectedDoctor!,
              //     onClose: () {
              //       setState(() {
              //         _selectedDoctor = null;
              //       });
              //     },
              //   ),
            ],
          );
        },
      ),
    );
  }
}

// Search bar widget
class _MapSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;

  const _MapSearchBar({required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16.h,
      left: 16.w,
      right: 16.w,
      child: CustomTextField(
        controller: controller,
        isEnabled: true,
        onChanged: onSearch,
      ),
    );
  }
}

// My Location button widget
class _MyLocationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double bottomOffset;

  const _MyLocationButton({
    required this.onPressed,
    required this.bottomOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottomOffset,
      right: 16.w,
      child: FloatingActionButton(
        heroTag: 'myLocation',
        mini: true,
        backgroundColor: Colors.white,
        onPressed: onPressed,
        child: const Icon(Icons.my_location, color: AppColors.midnightBlue),
      ),
    );
  }
}

// // Doctor details card widget
// class _DoctorDetailsCard extends StatelessWidget {
//   final DoctorModel doctor;
//   final VoidCallback onClose;

//   const _DoctorDetailsCard({required this.doctor, required this.onClose});

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       bottom: 0,
//       left: 0,
//       right: 0,
//       child: Container(
//         margin: EdgeInsets.all(16.w),
//         padding: EdgeInsets.all(16.r),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 20,
//               offset: const Offset(0, -5),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _DoctorAvatar(avatarUrl: doctor.avatarUrl),
//                 SizedBox(width: 12.w),
//                 Expanded(child: _DoctorInfo(doctor: doctor)),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   color: AppColors.grey400,
//                   onPressed: onClose,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Doctor avatar widget
// class _DoctorAvatar extends StatelessWidget {
//   final String? avatarUrl;

//   const _DoctorAvatar({this.avatarUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 80.w,
//       height: 80.w,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12.r),
//         color: AppColors.grey100,
//         image: avatarUrl != null
//             ? DecorationImage(
//                 image: NetworkImage(avatarUrl!),
//                 fit: BoxFit.cover,
//               )
//             : null,
//       ),
//       child: avatarUrl == null
//           ? const Icon(Icons.person, color: AppColors.grey400, size: 40)
//           : null,
//     );
//   }
// }

// // Doctor info widget
// class _DoctorInfo extends StatelessWidget {
//   final DoctorModel doctor;

//   const _DoctorInfo({required this.doctor});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           doctor.name,
//           style: TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w700,
//             color: AppColors.midnightBlue,
//           ),
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//         SizedBox(height: 4.h),
//         Text(
//           doctor.department ?? "Specialist",
//           style: TextStyle(
//             fontSize: 13.sp,
//             fontWeight: FontWeight.w500,
//             color: AppColors.grey500,
//           ),
//         ),
//         SizedBox(height: 8.h),
//         _LocationRow(address: doctor.address),
//         SizedBox(height: 8.h),
//         _RatingAndPriceRow(consultationFee: doctor.consultationFee),
//       ],
//     );
//   }
// }

// // Location row widget
// class _LocationRow extends StatelessWidget {
//   final String? address;

//   const _LocationRow({this.address});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(Icons.location_on, size: 14.sp, color: AppColors.grey500),
//         SizedBox(width: 4.w),
//         Expanded(
//           child: Text(
//             address ?? "Location unavailable",
//             style: TextStyle(fontSize: 12.sp, color: AppColors.grey500),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Rating and price row widget
// class _RatingAndPriceRow extends StatelessWidget {
//   final double consultationFee;

//   const _RatingAndPriceRow({required this.consultationFee});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Icon(Icons.star, color: AppColors.warning, size: 16),
//         SizedBox(width: 4.w),
//         Text(
//           "5.0",
//           style: TextStyle(
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w700,
//             color: AppColors.midnightBlue,
//           ),
//         ),
//         SizedBox(width: 8.w),
//         Container(height: 12, width: 1, color: AppColors.grey300),
//         SizedBox(width: 8.w),
//         Text(
//           "\$${consultationFee.toStringAsFixed(0)}",
//           style: TextStyle(
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w600,
//             color: AppColors.midnightBlue,
//           ),
//         ),
//       ],
//     );
//   }
// }
