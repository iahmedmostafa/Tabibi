import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/patient_profile/data/models/medical_profile_model.dart';
import 'package:tabibi/features/patient_profile/data/models/update_medical_profile_params.dart';

abstract class BaseMedicalProfileDataSource {
  Future<MedicalProfileModel> getMedicalProfile();
  Future<String> updateMedicalProfile(UpdateMedicalProfileParams params);
}

class MedicalProfileRemoteDataSource implements BaseMedicalProfileDataSource {
  final Dio dio;

  MedicalProfileRemoteDataSource(this.dio);

  @override
  Future<MedicalProfileModel> getMedicalProfile() async {
    try {
      final response = await dio.get(ApiConstance.medicalProfile);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MedicalProfileModel.fromJson(
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
  Future<String> updateMedicalProfile(
    UpdateMedicalProfileParams params,
  ) async {
    try {
      final response = await dio.put(
        ApiConstance.updateMedicalProfile,
        data: params.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return "Medical profile updated successfully";
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
