import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/doctor/profile/data/models/doctor_profile_model.dart';
import 'package:tabibi/features/doctor/profile/data/models/update_doctor_profile_request.dart';

abstract class DoctorProfileRemoteDataSource {
  Future<DoctorProfileModel> getDoctorProfile();
  Future<void> updateDoctorProfile(UpdateDoctorProfileRequest request);
}

class DoctorProfileRemoteDataSourceImpl implements DoctorProfileRemoteDataSource {
  final Dio dio;

  DoctorProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<DoctorProfileModel> getDoctorProfile() async {
    try {
      final response = await dio.get(ApiConstance.doctorProfile);

      if (response.statusCode == 200 && response.data != null) {
        return DoctorProfileModel.fromJson(response.data);
      } else {
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
  Future<void> updateDoctorProfile(UpdateDoctorProfileRequest request) async {
    try {
      final response = await dio.put(
        ApiConstance.updateDoctorProfile,
        data: request.toJson(),
      );

      if (response.statusCode != 204 &&
          response.statusCode != 200 &&
          response.statusCode != 201) {
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
          statusMessage: responseData.isNotEmpty ? responseData : 'An error occurred',
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
