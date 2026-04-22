import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/doctor/schedule/data/models/schedule_appointment_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleAppointmentModel>> getDoctorSchedule(String date);
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final Dio dio;

  ScheduleRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ScheduleAppointmentModel>> getDoctorSchedule(String date) async {
    try {
      final response = await dio.get(
        ApiConstance.doctorSchedule,
        queryParameters: {'date': date},
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((item) => ScheduleAppointmentModel.fromJson(item))
            .toList();
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
        );
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusMessage: e.message ?? "Unknown Error",
            statusCode: 500,
          ),
        );
      }
    }
  }
}
