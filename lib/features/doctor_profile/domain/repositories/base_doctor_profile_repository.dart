import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/doctor_profile/domain/entities/doctor_profile.dart';
import 'package:tabibi/features/doctor_profile/domain/entities/update_doctor_profile_params.dart';

abstract class BaseDoctorProfileRepository {
  Future<Either<Failure, DoctorProfile>> getDoctorProfile();
  Future<Either<Failure, String>> updateDoctorProfile(
    UpdateDoctorProfileParams params,
  );
  Future<Either<Failure, DoctorStatus>> doctorStatus();
}
