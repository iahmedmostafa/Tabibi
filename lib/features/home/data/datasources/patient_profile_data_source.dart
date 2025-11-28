import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/dio_interceptors.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/home/data/datasources/base_patient_profile_data_source.dart';
import 'package:tabibi/features/home/data/models/patient_profile_model.dart';

class PatientProfileDataSource implements BasePatientProfileDataSource {
  final Dio dio;

  PatientProfileDataSource(this.dio) {
    dio.options.baseUrl = ApiConstance.baseUrl;
    dio.interceptors.add(DioInterceptors(dio).interceptor);
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);
  }

  @override
  Future<PatientProfileModel> getPatientProfile() async {
    try {
      final response = await dio.get(ApiConstance.patientProfile);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PatientProfileModel.fromJson(
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
}
