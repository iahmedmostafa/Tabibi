import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/schedule/domain/entities/schedule_appointment.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, List<ScheduleAppointment>>> getDoctorSchedule(
    String date,
  );
}
