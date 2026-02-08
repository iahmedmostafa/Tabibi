import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/doctor_profile/data/models/doctor_profile_model.dart';
import 'package:tabibi/features/doctor_profile/data/models/update_doctor_profile_params.dart';

abstract class BaseDoctorProfileRepository {
  Future<Either<Failure, DoctorProfileModel>> getDoctorProfile();
  Future<Either<Failure, String>> updateDoctorProfile(
    UpdateDoctorProfileParams params,
  );
  Future<Either<Failure, DoctorStatus>> doctorStatus();
}
