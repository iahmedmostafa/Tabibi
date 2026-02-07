import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/patient_profile/data/models/patient_profile_model.dart';
import 'package:tabibi/features/patient_profile/domain/repositories/base_patient_profile_repository.dart';

class GetPatientProfileUseCase {
  final BasePatientProfileRepository repository;

  GetPatientProfileUseCase(this.repository);

  Future<Either<Failure, PatientProfileModel>> call() async {
    return await repository.getPatientProfile();
  }
}
