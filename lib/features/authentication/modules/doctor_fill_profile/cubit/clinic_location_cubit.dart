import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tabibi/core/services/location_services.dart';
import 'package:easy_localization/easy_localization.dart';

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
        throw Exception('locationDataNull'.tr());
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
          errorMessage: 'locationPermissionDenied'.tr(),
        ),
      );
    } on LocationServicesException {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'locationServicesDisabled'.tr(),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: isInitialLoad
              ? 'couldNotGetCurrentLocation'.tr()
              : 'couldNotGetLocationRetry'.tr(),
        ),
      );
    }
  }
}
