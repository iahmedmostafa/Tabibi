import 'package:dio/dio.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/features/booking/data/models/available_slot_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<List<AvailableSlotModel>> getAvailableSlots({
    required String doctorId,
    required String date,
  });
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final Dio dio;

  AppointmentRemoteDataSourceImpl(this.dio);

  @override
  Future<List<AvailableSlotModel>> getAvailableSlots({
    required String doctorId,
    required String date,
  }) async {
    final response = await dio.get(
      ApiConstance.availableSlots,
      queryParameters: {'doctorId': doctorId, 'date': date},
    );

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => AvailableSlotModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to fetch available slots");
    }
  }
}
