import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/booking/domain/repositories/appointment_repository.dart';

class CancelBookingUseCase {
  final AppointmentRepository repository;

  CancelBookingUseCase(this.repository);

  Future<Either<Failure, void>> execute({required String bookingId}) async {
    return await repository.cancelBooking(bookingId: bookingId);
  }
}
