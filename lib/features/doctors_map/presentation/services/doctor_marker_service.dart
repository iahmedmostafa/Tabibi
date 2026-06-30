import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tabibi/core/services/location_services.dart';
import 'package:tabibi/features/doctors_map/data/models/doctor_cluster.dart';
import 'package:tabibi/features/doctors_map/data/models/doctor_map_model.dart';

/// Handles all marker building and clustering logic for the doctors map.
class DoctorMarkerService {
  DoctorMarkerService({required LocationServices locationServices})
      : _locationServices = locationServices;

  final LocationServices _locationServices;
  final Map<String, BitmapDescriptor> _doctorCache = {};
  final Map<String, BitmapDescriptor> _clusterCache = {};

  // ─── Clustering ───────────────────────────────────────────────────────────────

  List<DoctorCluster> buildClusters(List<DoctorMapModel> doctors, double zoom) {
    if (doctors.length <= 3 || zoom >= 15) {
      return doctors
          .map((d) => DoctorCluster.single(d, LatLng(d.latitude, d.longitude)))
          .toList();
    }

    final gridSize = zoom >= 13
        ? 0.01
        : zoom >= 11
            ? 0.025
            : zoom >= 9
                ? 0.05
                : 0.09;

    final groups = <String, List<DoctorMapModel>>{};
    for (final d in doctors) {
      final key =
          '${(d.latitude / gridSize).floor()}_${(d.longitude / gridSize).floor()}';
      groups.putIfAbsent(key, () => []).add(d);
    }

    return groups.entries.map((entry) {
      final items = entry.value;
      final avgLat =
          items.fold<double>(0, (s, d) => s + d.latitude) / items.length;
      final avgLng =
          items.fold<double>(0, (s, d) => s + d.longitude) / items.length;
      return DoctorCluster(
        key: entry.key,
        doctors: items,
        center: LatLng(avgLat, avgLng),
      );
    }).toList()
      ..sort((a, b) => b.doctors.length.compareTo(a.doctors.length));
  }

  // ─── Marker building ──────────────────────────────────────────────────────────

  Future<BitmapDescriptor> getDoctorMarker(DoctorMapModel doctor) async {
    final key = 'doctor_${doctor.id}';
    if (_doctorCache.containsKey(key)) return _doctorCache[key]!;

    try {
      final Uint8List bytes = await _locationServices.getDoctorMarker(
        markerPath: 'assets/images/marker.png',
        imageUrl: doctor.avatarUrl,
        size: 50,
      );
      return _doctorCache[key] = BitmapDescriptor.bytes(bytes);
    } catch (_) {
      return _doctorCache[key] =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }

  Future<BitmapDescriptor> getClusterMarker({
    required int count,
    required bool isDark,
  }) async {
    final key = '${isDark ? 'dark' : 'light'}_$count';
    if (_clusterCache.containsKey(key)) return _clusterCache[key]!;

    final bytes = await _locationServices.getClusterMarker(
      count: count,
      isDark: isDark,
      size: 92,
    );
    return _clusterCache[key] = BitmapDescriptor.bytes(bytes);
  }

  void clearCache() {
    _doctorCache.clear();
    _clusterCache.clear();
  }
}
