import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor_profile/domain/entities/update_doctor_profile_params.dart';
import 'package:tabibi/features/doctor_profile/domain/repositories/base_doctor_profile_repository.dart';

class UpdateDoctorProfileUseCase {
  final BaseDoctorProfileRepository repository;

  UpdateDoctorProfileUseCase(this.repository);

  Future<Either<Failure, String>> call(UpdateDoctorProfileParams params) {
    return repository.updateDoctorProfile(params);
  }
}
