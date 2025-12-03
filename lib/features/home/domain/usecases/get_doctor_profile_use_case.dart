import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/home/data/models/doctor_profile_model.dart';
import 'package:tabibi/features/home/domain/repositories/base_doctor_profile_repository.dart';

class GetDoctorProfileUseCase {
  final BaseDoctorProfileRepository repository;

  GetDoctorProfileUseCase(this.repository);

  Future<Either<Failure, DoctorProfileModel>> call() async {
    return await repository.getDoctorProfile();
  }
}
