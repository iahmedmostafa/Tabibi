import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor_details/domain/entities/doctor_details_entity.dart';

abstract class DoctorDetailsRepository {
  Future<Either<Failure, DoctorDetails>> getDoctorDetails(String id);
}
