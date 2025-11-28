import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/home/data/models/patient_profile_model.dart';
import 'package:tabibi/features/home/domain/repositories/base_patient_profile_repository.dart';

class GetPatientProfileUseCase {
  final BasePatientProfileRepository repository;

  GetPatientProfileUseCase(this.repository);

  Future<Either<Failure, PatientProfileModel>> call() async {
    return await repository.getPatientProfile();
  }
}
