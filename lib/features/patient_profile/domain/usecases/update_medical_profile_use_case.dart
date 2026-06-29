import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/patient_profile/data/models/update_medical_profile_params.dart';
import 'package:tabibi/features/patient_profile/domain/repositories/base_medical_profile_repository.dart';

class UpdateMedicalProfileUseCase {
  final BaseMedicalProfileRepository repository;

  UpdateMedicalProfileUseCase(this.repository);

  Future<Either<Failure, String>> call(
    UpdateMedicalProfileParams params,
  ) async {
    return await repository.updateMedicalProfile(params);
  }
}
