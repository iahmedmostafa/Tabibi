import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tabibi/features/doctors_map/data/models/doctor_map_model.dart';
import 'package:tabibi/features/doctors_map/presentation/widgets/doctor_details_card.dart';
import 'package:tabibi/features/doctors_map/presentation/widgets/doctor_map_search_bar.dart';
import 'package:tabibi/features/doctors_map/presentation/widgets/map_empty_overlay.dart';
import 'package:tabibi/features/doctors_map/presentation/widgets/map_error_overlay.dart';
import 'package:tabibi/features/doctors_map/presentation/widgets/map_loading_overlay.dart';
import 'package:tabibi/features/doctors_map/presentation/widgets/my_location_button.dart';
import 'package:tabibi/features/doctors_map/presentation/widgets/search_this_area_button.dart';

/// The full map Stack: Google Map + all overlays + search bar + doctor card.
class DoctorsMapBody extends StatelessWidget {
  const DoctorsMapBody({
    super.key,
    required this.initialPosition,
    required this.markers,
    required this.selectedDoctor,
    required this.isLoading,
    required this.errorMessage,
    required this.showEmpty,
    required this.needsSearchThisArea,
    required this.searchController,
    required this.onMapCreated,
    required this.onCameraMoveStarted,
    required this.onMapTap,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onRefreshDoctors,
    required this.onGoToMyLocation,
    required this.onResetSearch,
    required this.onCloseDoctor,
    required this.onGoNow,
  });

  final CameraPosition initialPosition;
  final Set<Marker> markers;
  final DoctorMapModel? selectedDoctor;
  final bool isLoading;
  final String? errorMessage;
  final bool showEmpty;
  final bool needsSearchThisArea;
  final TextEditingController searchController;

  final void Function(GoogleMapController) onMapCreated;
  final VoidCallback onCameraMoveStarted;
  final void Function(LatLng) onMapTap;
  final void Function(String) onSearchChanged;
  final VoidCallback onClearSearch;
  final VoidCallback onRefreshDoctors;
  final VoidCallback onGoToMyLocation;
  final VoidCallback onResetSearch;
  final VoidCallback onCloseDoctor;
  final VoidCallback onGoNow;

  @override
  Widget build(BuildContext context) {
    final bottomOffset = selectedDoctor != null ? 228.h : 24.h;

    return Stack(
      children: [
        // ── Google Map ──────────────────────────────────────────────────────────
        Positioned.fill(
          child: GoogleMap(
            initialCameraPosition: initialPosition,
            markers: markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            onMapCreated: onMapCreated,
            onCameraMoveStarted: onCameraMoveStarted,
            onTap: onMapTap,
            padding: EdgeInsets.only(
              top: 130.h,
              bottom: bottomOffset,
              left: 16.w,
              right: 16.w,
            ),
          ),
        ),

        // ── Search bar + "Search this area" ─────────────────────────────────────
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
            child: Column(
              children: [
                DoctorMapSearchBar(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  onClear: onClearSearch,
                ),
                SizedBox(height: 12.h),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: needsSearchThisArea
                      ? SearchThisAreaButton(
                          key: const ValueKey('search_btn'),
                          onTap: onRefreshDoctors,
                        )
                      : const SizedBox.shrink(
                          key: ValueKey('search_btn_hidden'),
                        ),
                ),
              ],
            ),
          ),
        ),

        // ── Overlays ─────────────────────────────────────────────────────────────
        if (isLoading) const Positioned.fill(child: MapLoadingOverlay()),

        if (errorMessage != null)
          Positioned.fill(
            child: MapErrorOverlay(
              message: errorMessage!,
              onRetry: onRefreshDoctors,
            ),
          ),

        if (showEmpty)
          Positioned.fill(child: MapEmptyOverlay(onReset: onResetSearch)),

        // ── My-location FAB ──────────────────────────────────────────────────────
        MyLocationButton(
          onPressed: onGoToMyLocation,
          bottomOffset: bottomOffset,
        ),

        // ── Doctor detail card ───────────────────────────────────────────────────
        if (selectedDoctor != null)
          Positioned.fill(
            child: DraggableScrollableSheet(
              initialChildSize: 0.34,
              minChildSize: 0.25,
              maxChildSize: 0.62,
              builder: (_, scrollController) => DoctorDetailsCard(
                doctor: selectedDoctor!,
                scrollController: scrollController,
                onClose: onCloseDoctor,
                onGoNow: onGoNow,
              ),
            ),
          ),
      ],
    );
  }
}
