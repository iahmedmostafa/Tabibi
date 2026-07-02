import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/availability/data/models/update_schedule_params.dart';

abstract class AvailabilityRepository {
  Future<Either<Failure, List<ScheduleDayParams>>> getSchedule();
  Future<Either<Failure, void>> updateSchedule(UpdateScheduleParams params);
}
