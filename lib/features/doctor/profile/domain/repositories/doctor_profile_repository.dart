import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/profile/data/models/update_doctor_profile_request.dart';
import 'package:tabibi/features/doctor/profile/domain/entities/doctor_profile_entity.dart';

abstract class DoctorProfileRepository {
  Future<Either<Failure, DoctorProfileEntity>> getDoctorProfile();
  Future<Either<Failure, Unit>> updateDoctorProfile(UpdateDoctorProfileRequest request);
}
