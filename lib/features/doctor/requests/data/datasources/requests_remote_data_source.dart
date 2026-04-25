import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/doctor/requests/data/models/appointment_request_model.dart';

abstract class RequestsRemoteDataSource {
  Future<List<AppointmentRequestModel>> getAppointmentRequests();
  Future<void> completeAppointment(String id);
  Future<void> cancelAppointment(String id);
}

class RequestsRemoteDataSourceImpl implements RequestsRemoteDataSource {
  final Dio dio;

  RequestsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<AppointmentRequestModel>> getAppointmentRequests() async {
    try {
      final response = await dio.get(ApiConstance.doctorHome);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        if (data['todayAppointments'] == null) return [];
        final List appointmentsList = data['todayAppointments'];
        
        return appointmentsList
            .map((item) => AppointmentRequestModel.fromJson(item))
            .toList();
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

  @override
  Future<void> completeAppointment(String id) async {
    try {
      final response = await dio.patch(
        "${ApiConstance.doctorAppointments}/$id/complete",
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
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

  @override
  Future<void> cancelAppointment(String id) async {
    try {
      final response = await dio.patch(
        "${ApiConstance.doctorAppointments}/$id/cancel",
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
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
