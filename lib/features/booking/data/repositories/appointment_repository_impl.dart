import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
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
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.formattedErrors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createBooking({
    required String appointmentDate,
    required String doctorId,
    required int type,
  }) async {
    try {
      final result = await remoteDataSource.createBooking(
        appointmentDate: appointmentDate,
        doctorId: doctorId,
        type: type,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.formattedErrors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> confirmPayment({
    required String bookingId,
  }) async {
    try {
      await remoteDataSource.confirmPayment(bookingId: bookingId);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.formattedErrors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking({
    required String bookingId,
  }) async {
    try {
      await remoteDataSource.cancelBooking(bookingId: bookingId);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.formattedErrors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
