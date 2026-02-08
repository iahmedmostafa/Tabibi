import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/booking/data/datasources/appointment_remote_data_source.dart';
import 'package:tabibi/features/booking/domain/entities/available_slot.dart';
import 'package:tabibi/features/booking/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource remoteDataSource;

  AppointmentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<AvailableSlot>>> getAvailableSlots({
    required String doctorId,
    required String date,
  }) async {
    try {
      final result = await remoteDataSource.getAvailableSlots(
        doctorId: doctorId,
        date: date,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
