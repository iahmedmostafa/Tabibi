import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/booking/domain/entities/available_slot.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, List<AvailableSlot>>> getAvailableSlots({
    required String doctorId,
    required String date,
  });
}
