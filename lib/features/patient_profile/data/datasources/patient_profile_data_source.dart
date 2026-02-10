import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/patient_profile/data/datasources/base_patient_profile_data_source.dart';
import 'package:tabibi/features/patient_profile/data/models/patient_profile_model.dart';
import 'package:tabibi/features/patient_profile/data/models/update_patient_profile_params.dart';

class PatientProfileDataSource implements BasePatientProfileDataSource {
  final Dio dio;

  PatientProfileDataSource(this.dio);

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

  @override
  Future<String> updatePatientProfile(UpdatePatientProfileParams params) async {
    try {
      final response = await dio.put(
        ApiConstance.updatePatientProfile,
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
