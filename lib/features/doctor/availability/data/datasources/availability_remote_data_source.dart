import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/doctor/availability/data/models/update_schedule_params.dart';

abstract class BaseAvailabilityRemoteDataSource {
  Future<List<ScheduleDayParams>> getSchedule();
  Future<void> updateSchedule(UpdateScheduleParams params);
}

class AvailabilityRemoteDataSourceImpl
    implements BaseAvailabilityRemoteDataSource {
  final Dio dio;

  AvailabilityRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ScheduleDayParams>> getSchedule() async {
    try {
      final response = await dio.get(ApiConstance.getDoctorSchedule);

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((item) =>
                ScheduleDayParams.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(
          response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : <String, dynamic>{},
        ),
      );
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            e.response!.data as Map<String, dynamic>,
          ),
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> updateSchedule(UpdateScheduleParams params) async {
    try {
      final response = await dio.put(
        ApiConstance.updateDoctorSchedule,
        data: params.toJson(),
      );

      if (response.statusCode == 204) return;

      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(
          response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : <String, dynamic>{},
        ),
      );
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            e.response!.data as Map<String, dynamic>,
          ),
        );
      }
      rethrow;
    }
  }
}
