import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/clinic_location_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

/// Simple value object returned to the previous screen.
class ClinicLocationResult {
  const ClinicLocationResult({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

class ClinicLocationScreen extends StatefulWidget {
  const ClinicLocationScreen({super.key});

  @override
  State<ClinicLocationScreen> createState() => _ClinicLocationScreenState();
}

class _ClinicLocationScreenState extends State<ClinicLocationScreen> {
  GoogleMapController? _mapController;
  LatLng? _lastAnimatedTarget;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('selectClinicLocation'.tr())),
      body: BlocBuilder<ClinicLocationCubit, ClinicLocationState>(
        builder: (context, state) {
          final controller = _mapController;
          final target = state.cameraPosition.target;
          if (controller != null && _lastAnimatedTarget != target) {
            // to prevent animation when the map is first created
            _lastAnimatedTarget = target;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(target, state.cameraPosition.zoom),
              );
            });
          }

          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: state.cameraPosition,
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      myLocationEnabled: true,
                      markers: {
                        if (state.selectedLocation != null)
                          Marker(
                            markerId: const MarkerId('clinic_location'),
                            position: state.selectedLocation!,
                          ),
                      },
                      onTap: context.read<ClinicLocationCubit>().onMapTapped,
                    ),
                    if (state.isLoading)
                      const Positioned.fill(
                        child: IgnorePointer(
                          ignoring: true,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.errorMessage != null &&
                        state.errorMessage!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          state.errorMessage!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.red),
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: state.isLoading
                          ? null
                          : () {
                              context
                                  .read<ClinicLocationCubit>()
                                  .useCurrentLocation();
                            },
                      icon: const Icon(
                        Icons.my_location,
                        color: AppColors.textWhite,
                      ),
                      label: const Text(
                        'Use My Current Location',
                        style: TextStyle(color: AppColors.textWhite),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: state.selectedLocation == null
                          ? null
                          : () {
                              final pos = state.selectedLocation!;
                              context.pop(
                                ClinicLocationResult(
                                  latitude: pos.latitude,
                                  longitude: pos.longitude,
                                ),
                              );
                            },
                      child: const Text(
                        'Confirm Clinic Location',
                        style: TextStyle(color: AppColors.textWhite),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
