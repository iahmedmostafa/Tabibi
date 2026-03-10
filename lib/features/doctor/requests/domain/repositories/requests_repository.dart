import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/requests/domain/entities/appointment_request.dart';

abstract class RequestsRepository {
  Future<Either<Failure, List<AppointmentRequest>>> getAppointmentRequests();
  Future<Either<Failure, void>> approveAppointment(String id);
  Future<Either<Failure, void>> cancelAppointment(String id);
}
