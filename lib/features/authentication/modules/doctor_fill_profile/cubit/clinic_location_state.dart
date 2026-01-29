part of 'clinic_location_cubit.dart';

class ClinicLocationState extends Equatable {
  const ClinicLocationState({
    required this.selectedLocation,
    required this.isLoading,
    required this.errorMessage,
    required this.cameraPosition,
  });

  final LatLng? selectedLocation;
  final bool isLoading;
  final String? errorMessage;
  final CameraPosition cameraPosition;

  ClinicLocationState copyWith({
    LatLng? selectedLocation,
    bool? isLoading,
    String? errorMessage,
    CameraPosition? cameraPosition,
  }) {
    return ClinicLocationState(
      selectedLocation: selectedLocation ?? this.selectedLocation,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      cameraPosition: cameraPosition ?? this.cameraPosition,
    );
  }

  @override
  List<Object?> get props => [
    selectedLocation,
    isLoading,
    errorMessage,
    cameraPosition,
  ];
}
