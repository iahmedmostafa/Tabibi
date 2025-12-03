import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/dio_interceptors.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/home/data/datasources/base_doctor_profile_data_source.dart';
import 'package:tabibi/features/home/data/models/UpdateDoctorProfileParams.dart';
import 'package:tabibi/features/home/data/models/doctor_profile_model.dart';

class DoctorProfileDataSource implements BaseDoctorProfileDataSource {
  final Dio dio;

  DoctorProfileDataSource(this.dio) {
    dio.options.baseUrl = ApiConstance.baseUrl;
    dio.interceptors.add(DioInterceptors(dio).interceptor);
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);
  }

  @override
  Future<DoctorProfileModel> getDoctorProfile() async {
    try {
      final response = await dio.get(ApiConstance.updateDoctorProfile);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DoctorProfileModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

  @override
  Future<String> updateDoctorProfile(UpdateDoctorProfileParams params) async {
    try {
      final response = await dio.put(
        ApiConstance.updateDoctorProfile,
        data: params.toJson(),
      );

      if (response.statusCode == 204) {
        return "The Account Information Is Uploaded Successfully";
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }
}
