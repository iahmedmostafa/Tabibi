import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/home/data/models/patient_profile_model.dart';
import 'package:tabibi/features/home/data/models/update_patient_profile_params.dart';

abstract class BasePatientProfileRepository {
  Future<Either<Failure, PatientProfileModel>> getPatientProfile();
  Future<Either<Failure, String>> updatePatientProfile(
    UpdatePatientProfileParams params,
  );
}
