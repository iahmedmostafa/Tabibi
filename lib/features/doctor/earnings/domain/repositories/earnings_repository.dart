import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/earnings/domain/entities/earnings.dart';

abstract class EarningsRepository {
  Future<Either<Failure, EarningsSummary>> getSummary();
  Future<Either<Failure, List<ChartDataPoint>>> getAnalytics(
    EarningsPeriod period,
  );
  Future<Either<Failure, EarningsTransactionsPage>> getTransactions({
    required int page,
    required int pageSize,
  });
}
