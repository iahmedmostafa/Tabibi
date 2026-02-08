import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/doctor_profile/domain/repositories/base_doctor_profile_repository.dart';

class DoctorStatusUseCase {
  final BaseDoctorProfileRepository repository;

  DoctorStatusUseCase(this.repository);

  Future<Either<Failure, DoctorStatus>> call() async {
    return await repository.doctorStatus();
  }
}
