import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/doctor/earnings/domain/entities/earnings.dart';
import 'package:tabibi/features/doctor/earnings/domain/repositories/earnings_repository.dart';

class GetEarningsSummaryUseCase
    extends BaseUseCase<EarningsSummary, NoParameters> {
  final EarningsRepository repository;

  GetEarningsSummaryUseCase(this.repository);

  @override
  Future<Either<Failure, EarningsSummary>> call(NoParameters parameters) {
    return repository.getSummary();
  }
}

class GetEarningsAnalyticsUseCase
    extends BaseUseCase<List<ChartDataPoint>, EarningsPeriod> {
  final EarningsRepository repository;

  GetEarningsAnalyticsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChartDataPoint>>> call(
    EarningsPeriod parameters,
  ) {
    return repository.getAnalytics(parameters);
  }
}

class GetEarningsTransactionsUseCase
    extends BaseUseCase<EarningsTransactionsPage, EarningsTransactionsParams> {
  final EarningsRepository repository;

  GetEarningsTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, EarningsTransactionsPage>> call(
    EarningsTransactionsParams parameters,
  ) {
    return repository.getTransactions(
      page: parameters.page,
      pageSize: parameters.pageSize,
    );
  }
}

class EarningsTransactionsParams extends Equatable {
  final int page;
  final int pageSize;

  const EarningsTransactionsParams({
    required this.page,
    required this.pageSize,
  });

  @override
  List<Object?> get props => [page, pageSize];
}
