import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/services/location_services.dart';
import 'package:tabibi/features/doctors_map/data/models/doctor_map_model.dart';
import 'package:tabibi/features/doctors_map/presentation/controller/doctor_map_cubit.dart';
import 'package:tabibi/features/doctors_map/presentation/controller/doctor_map_state.dart';
import 'package:tabibi/features/doctors_map/presentation/services/doctor_marker_service.dart';
import 'package:tabibi/features/doctors_map/presentation/widgets/doctors_map_body.dart';
import 'package:tabibi/features/doctors_map/utils/map_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorsMapScreen extends StatefulWidget {
  const DoctorsMapScreen({super.key});

  @override
  State<DoctorsMapScreen> createState() => _DoctorsMapScreenState();
}

class _DoctorsMapScreenState extends State<DoctorsMapScreen> {
  static const _initialPosition = CameraPosition(
    target: LatLng(30.0444, 31.2357),
    zoom: 12,
  );

  late final DoctorMapCubit _cubit;
  late final DoctorMarkerService _markerService;
  final LocationServices _locationServices = sl<LocationServices>();
  final TextEditingController _searchController = TextEditingController();

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  List<DoctorMapModel> _allDoctors = [];
  List<DoctorMapModel> _filteredDoctors = [];
  DoctorMapModel? _selectedDoctor;
  bool _isLoading = true;
  bool _needsSearchThisArea = false;
  String? _errorMessage;
  String _searchQuery = '';

  // ─── Lifecycle ────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _cubit = sl<DoctorMapCubit>();
    _markerService = DoctorMarkerService(locationServices: _locationServices);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applyMapStyle();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    _cubit.close();
    super.dispose();
  }

  // ─── Map ─────────────────────────────────────────────────────────────────────

  Future<void> _applyMapStyle() async {
    if (_mapController == null) return;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    await _mapController!.setMapStyle(isDark ? kDarkMapStyle : null);
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    await _applyMapStyle();
    await _refreshDoctors();
  }

  Future<void> _refreshDoctors() async {
    if (_mapController == null) return;
    final bounds = await _mapController!.getVisibleRegion();
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _needsSearchThisArea = false;
    });
    await _cubit.getDoctorsOnMap(
      minLat: bounds.southwest.latitude,
      maxLat: bounds.northeast.latitude,
      minLng: bounds.southwest.longitude,
      maxLng: bounds.northeast.longitude,
    );
  }

  // ─── BLoC state ───────────────────────────────────────────────────────────────

  void _handleState(DoctorMapState state) {
    if (state is DoctorMapLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    } else if (state is DoctorMapSuccess) {
      _allDoctors = state.doctors;
      _isLoading = false;
      _errorMessage = null;
      _applyCurrentFilter();
    } else if (state is DoctorMapError) {
      setState(() {
        _isLoading = false;
        _errorMessage = state.message;
        _markers = {};
        _allDoctors = [];
        _filteredDoctors = [];
        _selectedDoctor = null;
      });
    }
  }

  // ─── Search ───────────────────────────────────────────────────────────────────

  void _applyCurrentFilter() {
    final query = _searchQuery.trim().toLowerCase();
    final filtered = query.isEmpty
        ? List<DoctorMapModel>.from(_allDoctors)
        : _allDoctors.where((d) {
            return (d.name).toLowerCase().contains(query);
          }).toList();

    final keepSelected =
        _selectedDoctor != null &&
        filtered.any((d) => d.id == _selectedDoctor!.id);

    setState(() {
      _filteredDoctors = filtered;
      if (!keepSelected) _selectedDoctor = null;
    });
    _rebuildMarkers();
  }

  void _onSearchChanged(String v) {
    setState(() => _searchQuery = v);
    _applyCurrentFilter();
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  void _clearSelection() {
    if (_selectedDoctor != null) setState(() => _selectedDoctor = null);
  }

  Future<void> _resetSearch() async {
    _clearSearch();
    await _refreshDoctors();
  }

  // ─── Location ─────────────────────────────────────────────────────────────────

  Future<void> _goToMyLocation() async {
    try {
      final LocationData loc = await _locationServices.getLocation();
      final pos = LatLng(loc.latitude!, loc.longitude!);
      await _mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 14));
      setState(() {
        _markers = {
          ..._markers,
          Marker(markerId: const MarkerId('myLocation'), position: pos),
        };
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get your location')),
        );
      }
    }
  }

  Future<void> _openDoctorLocation(DoctorMapModel doctor) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${doctor.latitude},${doctor.longitude}&travelmode=driving',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
        mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps')),
      );
    }
  }

  // ─── Markers ─────────────────────────────────────────────────────────────────

  Future<void> _rebuildMarkers() async {
    if (!mounted || _filteredDoctors.isEmpty) {
      if (mounted) setState(() => _markers = {});
      return;
    }
    final zoom = _mapController == null
        ? 12.0
        : await _mapController!.getZoomLevel();
    final clusters = _markerService.buildClusters(_filteredDoctors, zoom);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final built = await Future.wait(
      clusters.map((c) async {
        if (!c.isCluster) {
          final doc = c.doctors.first;
          return Marker(
            markerId: MarkerId('doctor_${doc.id}'),
            position: c.center,
            icon: await _markerService.getDoctorMarker(doc),
            zIndexInt: 2,
            onTap: () => setState(() => _selectedDoctor = doc),
          );
        }
        return Marker(
          markerId: MarkerId('cluster_${c.key}'),
          position: c.center,
          icon: await _markerService.getClusterMarker(
            count: c.doctors.length,
            isDark: isDark,
          ),
          zIndex: 1,
          onTap: () => _zoomIntoCluster(c.center, zoom),
        );
      }),
    );

    if (mounted) setState(() => _markers = built.toSet());
  }

  Future<void> _zoomIntoCluster(LatLng center, double zoom) async {
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: center, zoom: (zoom + 1.8).clamp(12.0, 17.0)),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: BlocConsumer<DoctorMapCubit, DoctorMapState>(
          listener: (_, state) => _handleState(state),
          builder: (_, __) => DoctorsMapBody(
            initialPosition: _initialPosition,
            markers: _markers,
            selectedDoctor: _selectedDoctor,
            isLoading: _isLoading,
            errorMessage: _errorMessage,
            showEmpty:
                !_isLoading &&
                _errorMessage == null &&
                _filteredDoctors.isEmpty,
            needsSearchThisArea: _needsSearchThisArea,
            searchController: _searchController,
            onMapCreated: _onMapCreated,
            onCameraMoveStarted: () =>
                setState(() => _needsSearchThisArea = true),
            onMapTap: (_) => _clearSelection(),
            onSearchChanged: _onSearchChanged,
            onClearSearch: _clearSearch,
            onRefreshDoctors: _refreshDoctors,
            onGoToMyLocation: _goToMyLocation,
            onResetSearch: _resetSearch,
            onCloseDoctor: _clearSelection,
            onGoNow: () => _openDoctorLocation(_selectedDoctor!),
          ),
        ),
      ),
    );
  }
}
