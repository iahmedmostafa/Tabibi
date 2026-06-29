import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/patient_profile/data/models/medical_profile_model.dart';
import 'package:tabibi/features/patient_profile/domain/repositories/base_medical_profile_repository.dart';

class GetMedicalProfileUseCase {
  final BaseMedicalProfileRepository repository;

  GetMedicalProfileUseCase(this.repository);

  Future<Either<Failure, MedicalProfileModel>> call() async {
    return await repository.getMedicalProfile();
  }
}
