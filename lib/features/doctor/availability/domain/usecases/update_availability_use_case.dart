import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/availability/data/models/update_schedule_params.dart';
import 'package:tabibi/features/doctor/availability/domain/repositories/availability_repository.dart';

class UpdateAvailabilityUseCase {
  final AvailabilityRepository repository;

  UpdateAvailabilityUseCase(this.repository);

  Future<Either<Failure, void>> call(UpdateScheduleParams params) async {
    return await repository.updateSchedule(params);
  }
}
