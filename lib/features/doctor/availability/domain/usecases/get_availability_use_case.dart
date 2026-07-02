import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/availability/data/models/update_schedule_params.dart';
import 'package:tabibi/features/doctor/availability/domain/repositories/availability_repository.dart';

class GetAvailabilityUseCase {
  final AvailabilityRepository repository;

  GetAvailabilityUseCase(this.repository);

  Future<Either<Failure, List<ScheduleDayParams>>> call() async {
    return await repository.getSchedule();
  }
}
