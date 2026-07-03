import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/patient_profile/data/models/medical_profile_model.dart';

abstract class PatientMedicalProfileRemoteDataSource {
  Future<MedicalProfileModel> getMedicalProfile(String patientId);
}

class PatientMedicalProfileRemoteDataSourceImpl
    implements PatientMedicalProfileRemoteDataSource {
  final Dio dio;

  PatientMedicalProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<MedicalProfileModel> getMedicalProfile(String patientId) async {
    try {
      final response = await dio.get(
        ApiConstance.medicalProfileByPatientId(patientId),
      );

      if (response.statusCode == 200) {
        return MedicalProfileModel.fromJson(
          response.data as Map<String, dynamic>,
        );
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
}
