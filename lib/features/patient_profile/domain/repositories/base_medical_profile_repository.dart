import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/patient_profile/data/models/medical_profile_model.dart';
import 'package:tabibi/features/patient_profile/data/models/update_medical_profile_params.dart';

abstract class BaseMedicalProfileRepository {
  Future<Either<Failure, MedicalProfileModel>> getMedicalProfile();
  Future<Either<Failure, String>> updateMedicalProfile(
    UpdateMedicalProfileParams params,
  );
}
