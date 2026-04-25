import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/doctor/schedule/domain/entities/schedule_appointment.dart';
import 'package:tabibi/features/doctor/schedule/domain/repositories/schedule_repository.dart';

class GetDoctorScheduleUseCase
    extends BaseUseCase<List<ScheduleAppointment>, String> {
  final ScheduleRepository repository;

  GetDoctorScheduleUseCase(this.repository);

  @override
  Future<Either<Failure, List<ScheduleAppointment>>> call(
    String parameters,
  ) async {
    return await repository.getDoctorSchedule(parameters);
  }
}
