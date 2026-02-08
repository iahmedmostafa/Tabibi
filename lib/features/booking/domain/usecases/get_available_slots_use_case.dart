import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/booking/domain/entities/available_slot.dart';
import 'package:tabibi/features/booking/domain/repositories/appointment_repository.dart';

class GetAvailableSlotsUseCase {
  final AppointmentRepository repository;

  GetAvailableSlotsUseCase(this.repository);

  Future<Either<Failure, List<AvailableSlot>>> execute({
    required String doctorId,
    required String date,
  }) async {
    return await repository.getAvailableSlots(doctorId: doctorId, date: date);
  }
}
