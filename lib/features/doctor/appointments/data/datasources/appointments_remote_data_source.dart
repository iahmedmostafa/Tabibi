import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/doctor/appointments/data/models/appointment_details_model.dart';

abstract class AppointmentsRemoteDataSource {
  Future<AppointmentDetailsModel> getAppointmentDetails(String id);
}

class AppointmentsRemoteDataSourceImpl implements AppointmentsRemoteDataSource {
  final Dio dio;

  AppointmentsRemoteDataSourceImpl(this.dio);

  @override
  Future<AppointmentDetailsModel> getAppointmentDetails(String id) async {
    try {
      final response = await dio.get(
        "${ApiConstance.doctorAppointments}/$id",
      );

      if (response.statusCode == 200) {
        return AppointmentDetailsModel.fromJson(response.data);
      } else {
        final responseData = response.data;
        if (responseData is String) {
          throw ServerException(
            errorMessageModel: ErrorMessageModel(
              statusCode: response.statusCode ?? 400,
              statusMessage: responseData.isNotEmpty ? responseData : 'Unknown error',
            ),
          );
        }
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(responseData),
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        if (errorData is String) {
          throw ServerException(
            errorMessageModel: ErrorMessageModel(
              statusCode: e.response!.statusCode ?? 400,
              statusMessage: errorData.isNotEmpty ? errorData : 'An error occurred',
            ),
          );
        }
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(errorData),
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
