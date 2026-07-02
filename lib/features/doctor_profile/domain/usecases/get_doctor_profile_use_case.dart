import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor_profile/domain/entities/doctor_profile.dart';
import 'package:tabibi/features/doctor_profile/domain/repositories/base_doctor_profile_repository.dart';

class GetDoctorProfileUseCase {
  final BaseDoctorProfileRepository repository;

  GetDoctorProfileUseCase(this.repository);

  Future<Either<Failure, DoctorProfile>> call() {
    return repository.getDoctorProfile();
  }
}
