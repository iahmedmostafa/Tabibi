import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/schedule/data/datasources/schedule_remote_data_source.dart';
import 'package:tabibi/features/doctor/schedule/domain/entities/schedule_appointment.dart';
import 'package:tabibi/features/doctor/schedule/domain/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ScheduleAppointment>>> getDoctorSchedule(
    String date,
  ) async {
    try {
      final result = await remoteDataSource.getDoctorSchedule(date);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
