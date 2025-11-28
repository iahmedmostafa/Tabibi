import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/home/data/models/patient_profile_model.dart';

abstract class BasePatientProfileRepository {
  Future<Either<Failure, PatientProfileModel>> getPatientProfile();
}
