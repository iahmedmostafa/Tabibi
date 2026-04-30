import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/doctor/prescription/data/models/create_prescription_request_model.dart';

abstract class DoctorPrescriptionRemoteDataSource {
  Future<void> createPrescription({
    required String appointmentId,
    required CreatePrescriptionRequestModel request,
  });

  Future<void> completeAppointment({required String appointmentId});
}

class DoctorPrescriptionRemoteDataSourceImpl
    implements DoctorPrescriptionRemoteDataSource {
  final Dio dio;

  DoctorPrescriptionRemoteDataSourceImpl(this.dio);

  @override
  Future<void> createPrescription({
    required String appointmentId,
    required CreatePrescriptionRequestModel request,
  }) async {
    try {
      final response = await dio.post(
        '${ApiConstance.doctorAppointments}/$appointmentId/prescription',
        data: request.toJson(),
      );

      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        _throwServerException(response.statusCode, response.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        _throwServerException(e.response!.statusCode, e.response!.data);
      }
      throw ServerException(
        errorMessageModel: ErrorMessageModel(
          statusCode: 500,
          statusMessage: e.message ?? 'Unknown Error',
        ),
      );
    }
  }

  @override
  Future<void> completeAppointment({required String appointmentId}) async {
    try {
      final response = await dio.patch(
        '${ApiConstance.doctorAppointments}/$appointmentId/complete',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        _throwServerException(response.statusCode, response.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        _throwServerException(e.response!.statusCode, e.response!.data);
      }
      throw ServerException(
        errorMessageModel: ErrorMessageModel(
          statusCode: 500,
          statusMessage: e.message ?? 'Unknown Error',
        ),
      );
    }
  }

  Never _throwServerException(int? statusCode, dynamic responseData) {
    if (responseData is String) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel(
          statusCode: statusCode ?? 400,
          statusMessage: responseData.isNotEmpty
              ? responseData
              : 'An error occurred',
        ),
      );
    }

    if (responseData is Map<String, dynamic>) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(responseData),
      );
    }

    throw ServerException(
      errorMessageModel: ErrorMessageModel(
        statusCode: statusCode ?? 400,
        statusMessage: 'An error occurred',
      ),
    );
  }
}
