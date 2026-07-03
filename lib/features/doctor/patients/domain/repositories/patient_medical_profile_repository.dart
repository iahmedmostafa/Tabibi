import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/patient_profile/data/models/medical_profile_model.dart';

abstract class PatientMedicalProfileRepository {
  Future<Either<Failure, MedicalProfileModel>> getMedicalProfile(
    String patientId,
  );
}
