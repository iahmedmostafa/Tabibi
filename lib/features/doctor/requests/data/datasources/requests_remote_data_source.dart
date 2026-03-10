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
      // NOTE: Using schedule endpoint as a fallback since specific "requests" endpoint doesn't exist
      // Will fetch schedule without date to get all and filter locally, or API might default to upcoming
      final response = await dio.get(ApiConstance.doctorSchedule);

      if (response.statusCode == 200) {
        // Fetch only those that might be considered "requests"
        // Let's assume status 0 is pending/request.
        // We will map the schedule items to AppointmentRequestModel
        final List data = response.data;
        return data
            .where((item) => item['status'] == 0 || item['status'] == 1) // Allow pending/scheduled
            .map((item) => AppointmentRequestModel.fromJson(item))
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

  @override
  Future<void> completeAppointment(String id) async {
    try {
      final response = await dio.patch(
        "\${ApiConstance.doctorAppointments}/$id/complete",
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
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

  @override
  Future<void> cancelAppointment(String id) async {
    try {
      final response = await dio.patch(
        "\${ApiConstance.doctorAppointments}/$id/cancel",
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
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
