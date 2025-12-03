import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/home/data/models/UpdateDoctorProfileParams.dart';
import 'package:tabibi/features/home/data/models/doctor_profile_model.dart';

abstract class BaseDoctorProfileRepository {
  Future<Either<Failure, DoctorProfileModel>> getDoctorProfile();
  Future<Either<Failure, String>> updateDoctorProfile(
    UpdateDoctorProfileParams params,
  );
}
