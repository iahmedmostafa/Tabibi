import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/dashboard_response.dart';
import 'package:tabibi/features/doctor/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DashboardResponse>> getDoctorDashboard() async {
    try {
      final result = await remoteDataSource.getDoctorDashboard();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
