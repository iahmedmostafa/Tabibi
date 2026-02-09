import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/booking/domain/repositories/appointment_repository.dart';

class CreateBookingUseCase {
  final AppointmentRepository repository;

  CreateBookingUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    required String appointmentDate,
    required String doctorId,
    required int type,
  }) async {
    return await repository.createBooking(
      appointmentDate: appointmentDate,
      doctorId: doctorId,
      type: type,
    );
  }
}
