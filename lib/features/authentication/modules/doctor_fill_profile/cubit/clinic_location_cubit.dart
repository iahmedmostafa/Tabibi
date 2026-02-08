import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tabibi/core/services/location_services.dart';

part 'clinic_location_state.dart';

class ClinicLocationCubit extends Cubit<ClinicLocationState> {
  ClinicLocationCubit(this._locationServices)
    : super(
        const ClinicLocationState(
          selectedLocation: null,
          isLoading: false,
          errorMessage: null,
          cameraPosition: CameraPosition(
            target: LatLng(30.0444, 31.2357), // Default: Cairo
            zoom: 12,
          ),
        ),
      );

  final LocationServices _locationServices;

  Future<void> initialize() async {
    await _moveToCurrentLocation(setAsSelected: true, isInitialLoad: true);
  }

  /// Called when user taps on the map.
  void onMapTapped(LatLng position) {
    emit(
      state.copyWith(
        selectedLocation: position,
        cameraPosition: CameraPosition(target: position, zoom: 16),
      ),
    );
  }

  /// Called when user presses "Use My Current Location".
  Future<void> useCurrentLocation() async {
    await _moveToCurrentLocation(setAsSelected: true, isInitialLoad: false);
  }

  Future<void> _moveToCurrentLocation({
    required bool setAsSelected,
    required bool isInitialLoad,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));
      final locationData = await _locationServices.getLocation();

      final lat = locationData.latitude;
      final lng = locationData.longitude;
      if (lat == null || lng == null) {
        throw Exception('Location data is null');
      }

      final latLng = LatLng(lat, lng);

      emit(
        state.copyWith(
          isLoading: false,
          selectedLocation: setAsSelected ? latLng : state.selectedLocation,
          cameraPosition: CameraPosition(target: latLng, zoom: 16),
        ),
      );
    } on LocationPermissionException {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage:
              'Location permission denied. You can still tap on the map to choose the clinic location.',
        ),
      );
    } on LocationServicesException {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage:
              'Location services are disabled. Please enable GPS or tap on the map to choose the clinic location.',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: isInitialLoad
              ? 'Could not get current location. Showing default map. You can tap on the map to choose the clinic location.'
              : 'Could not get current location. Please try again or tap on the map.',
        ),
      );
    }
  }
}
