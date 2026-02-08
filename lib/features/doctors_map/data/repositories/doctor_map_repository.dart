import '../datasources/doctor_map_remote_data_source.dart';
import '../models/doctor_map_model.dart';

abstract class DoctorMapRepository {
  Future<List<DoctorMapModel>> getDoctorsOnMap({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  });
}

class DoctorMapRepositoryImpl implements DoctorMapRepository {
  final DoctorMapRemoteDataSource remoteDataSource;

  DoctorMapRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<DoctorMapModel>> getDoctorsOnMap({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) {
    return remoteDataSource.getDoctorsOnMap(
      minLat: minLat,
      maxLat: maxLat,
      minLng: minLng,
      maxLng: maxLng,
    );
  }
}
