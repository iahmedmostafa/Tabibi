import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/requests/data/datasources/requests_remote_data_source.dart';
import 'package:tabibi/features/doctor/requests/domain/entities/appointment_request.dart';
import 'package:tabibi/features/doctor/requests/domain/repositories/requests_repository.dart';

class RequestsRepositoryImpl implements RequestsRepository {
  final RequestsRemoteDataSource remoteDataSource;

  RequestsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<AppointmentRequest>>> getAppointmentRequests() async {
    try {
      final result = await remoteDataSource.getAppointmentRequests();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> approveAppointment(String id) async {
    try {
      await remoteDataSource.completeAppointment(id);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> cancelAppointment(String id) async {
    try {
      await remoteDataSource.cancelAppointment(id);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
