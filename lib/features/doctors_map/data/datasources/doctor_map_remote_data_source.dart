import 'package:dio/dio.dart';
import 'package:tabibi/core/network/api_constance.dart';

import '../models/doctor_map_model.dart';

abstract class DoctorMapRemoteDataSource {
  Future<List<DoctorMapModel>> getDoctorsOnMap({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  });
}

class DoctorMapRemoteDataSourceImpl implements DoctorMapRemoteDataSource {
  final Dio dio;

  DoctorMapRemoteDataSourceImpl(this.dio);

  @override
  Future<List<DoctorMapModel>> getDoctorsOnMap({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) async {
    try {
      final response = await dio.get(
        ApiConstance.doctorsMap,
        queryParameters: {
          'minLat': minLat,
          'maxLat': maxLat,
          'minLng': minLng,
          'maxLng': maxLng,
        },
      );

      return (response.data as List)
          .map((e) => DoctorMapModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Server error');
    }
  }
}
