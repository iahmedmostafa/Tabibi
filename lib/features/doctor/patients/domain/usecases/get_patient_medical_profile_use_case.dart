import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/patients/domain/repositories/patient_medical_profile_repository.dart';
import 'package:tabibi/features/patient_profile/data/models/medical_profile_model.dart';

class GetPatientMedicalProfileUseCase {
  final PatientMedicalProfileRepository repository;

  GetPatientMedicalProfileUseCase(this.repository);

  Future<Either<Failure, MedicalProfileModel>> call(
    String patientId,
  ) async {
    return await repository.getMedicalProfile(patientId);
  }
}
