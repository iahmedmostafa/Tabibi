import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/patient_profile/data/models/update_patient_profile_params.dart';
import 'package:tabibi/features/patient_profile/domain/repositories/base_patient_profile_repository.dart';

class UpdatePatientProfileUseCase {
  final BasePatientProfileRepository repository;

  UpdatePatientProfileUseCase(this.repository);

  Future<Either<Failure, String>> call(
    UpdatePatientProfileParams params,
  ) async {
    return await repository.updatePatientProfile(params);
  }
}
