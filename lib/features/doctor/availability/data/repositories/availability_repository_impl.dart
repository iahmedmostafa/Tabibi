import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/availability/data/datasources/availability_remote_data_source.dart';
import 'package:tabibi/features/doctor/availability/data/models/update_schedule_params.dart';
import 'package:tabibi/features/doctor/availability/domain/repositories/availability_repository.dart';

class AvailabilityRepositoryImpl implements AvailabilityRepository {
  final BaseAvailabilityRemoteDataSource remoteDataSource;

  AvailabilityRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ScheduleDayParams>>> getSchedule() async {
    try {
      final result = await remoteDataSource.getSchedule();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(failure.errorMessageModel.statusMessage),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSchedule(
    UpdateScheduleParams params,
  ) async {
    try {
      await remoteDataSource.updateSchedule(params);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(failure.errorMessageModel.statusMessage),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
