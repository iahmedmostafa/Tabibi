import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/home/data/models/UpdateDoctorProfileParams.dart';
import 'package:tabibi/features/home/domain/repositories/base_doctor_profile_repository.dart';

class UpdateDoctorProfileUseCase {
  final BaseDoctorProfileRepository repository;

  UpdateDoctorProfileUseCase(this.repository);

  Future<Either<Failure, String>> call(UpdateDoctorProfileParams params) async {
    return await repository.updateDoctorProfile(params);
  }
}
