import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tabibi/features/doctors_map/data/models/doctor_map_model.dart';

class DoctorCluster {
  final String key;
  final List<DoctorMapModel> doctors;
  final LatLng center;

  const DoctorCluster({
    required this.key,
    required this.doctors,
    required this.center,
  });

  factory DoctorCluster.single(DoctorMapModel doctor, LatLng center) {
    return DoctorCluster(
      key: doctor.id,
      doctors: [doctor],
      center: center,
    );
  }

  bool get isCluster => doctors.length > 1;
}
