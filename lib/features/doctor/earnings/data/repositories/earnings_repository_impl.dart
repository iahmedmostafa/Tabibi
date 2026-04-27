import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/earnings/data/datasources/earnings_remote_data_source.dart';
import 'package:tabibi/features/doctor/earnings/domain/entities/earnings.dart';
import 'package:tabibi/features/doctor/earnings/domain/repositories/earnings_repository.dart';

class EarningsRepositoryImpl implements EarningsRepository {
  final EarningsRemoteDataSource remoteDataSource;

  EarningsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, EarningsSummary>> getSummary() async {
    try {
      return Right(await remoteDataSource.getSummary());
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChartDataPoint>>> getAnalytics(
    EarningsPeriod period,
  ) async {
    try {
      return Right(await remoteDataSource.getAnalytics(period));
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EarningsTransactionsPage>> getTransactions({
    required int page,
    required int pageSize,
  }) async {
    try {
      return Right(
        await remoteDataSource.getTransactions(page: page, pageSize: pageSize),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
