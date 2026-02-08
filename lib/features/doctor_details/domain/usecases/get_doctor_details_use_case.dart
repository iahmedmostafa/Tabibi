import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor_details/domain/entities/doctor_details_entity.dart';
import 'package:tabibi/features/doctor_details/domain/repositories/doctor_details_repository.dart';

class GetDoctorDetailsUseCase {
  final DoctorDetailsRepository repository;

  GetDoctorDetailsUseCase(this.repository);

  Future<Either<Failure, DoctorDetails>> execute(String id) async {
    return await repository.getDoctorDetails(id);
  }
}
