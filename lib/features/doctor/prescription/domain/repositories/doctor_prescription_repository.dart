import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/prescription/domain/entities/create_prescription_request.dart';

abstract class DoctorPrescriptionRepository {
  Future<Either<Failure, void>> createPrescription({
    required String appointmentId,
    required CreatePrescriptionRequest request,
  });

  Future<Either<Failure, void>> completeAppointment({
    required String appointmentId,
  });
}
