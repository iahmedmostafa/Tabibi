import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/doctor/earnings/domain/entities/earnings.dart';
import 'package:tabibi/features/doctor/earnings/domain/usecases/earnings_usecases.dart';
import 'package:tabibi/features/doctor/earnings/presentation/cubit/earnings_state.dart';

class EarningsCubit extends Cubit<EarningsState> {
  final GetEarningsSummaryUseCase getSummaryUseCase;
  final GetEarningsAnalyticsUseCase getAnalyticsUseCase;
  final GetEarningsTransactionsUseCase getTransactionsUseCase;

  static const int _pageSize = 10;

  EarningsCubit(
    this.getSummaryUseCase,
    this.getAnalyticsUseCase,
    this.getTransactionsUseCase,
  ) : super(const EarningsState());

  Future<void> loadDashboard() async {
    emit(
      state.copyWith(
        status: EarningsLoadStatus.loading,
        analyticsStatus: EarningsLoadStatus.loading,
        transactionsStatus: EarningsLoadStatus.loading,
        errorMessage: null,
        analyticsErrorMessage: null,
        transactionsErrorMessage: null,
      ),
    );

    await Future.wait([
      _loadSummary(),
      _loadAnalytics(state.selectedPeriod),
      refreshTransactions(),
    ]);
  }

  Future<void> retryDashboard() => loadDashboard();

  Future<void> _loadSummary() async {
    final result = await getSummaryUseCase(const NoParameters());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EarningsLoadStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (summary) => emit(
        state.copyWith(
          status: EarningsLoadStatus.success,
          summary: summary,
          chartData: state.chartData.isEmpty
              ? summary.weeklyChartData
              : state.chartData,
        ),
      ),
    );
  }

  Future<void> selectAnalyticsPeriod(EarningsPeriod period) async {
    if (state.selectedPeriod == period &&
        state.analyticsStatus == EarningsLoadStatus.success) {
      return;
    }
    await _loadAnalytics(period);
  }

  Future<void> retryAnalytics() => _loadAnalytics(state.selectedPeriod);

  Future<void> _loadAnalytics(EarningsPeriod period) async {
    emit(
      state.copyWith(
        selectedPeriod: period,
        analyticsStatus: EarningsLoadStatus.loading,
        analyticsErrorMessage: null,
      ),
    );

    final result = await getAnalyticsUseCase(period);
    result.fold(
      (failure) => emit(
        state.copyWith(
          analyticsStatus: EarningsLoadStatus.failure,
          analyticsErrorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          analyticsStatus: EarningsLoadStatus.success,
          chartData: data,
        ),
      ),
    );
  }

  Future<void> refreshTransactions() async {
    emit(
      state.copyWith(
        transactionsStatus: EarningsLoadStatus.loading,
        transactionsErrorMessage: null,
        transactions: const [],
        currentPage: 0,
        hasNextPage: false,
      ),
    );

    await _loadTransactionsPage(1);
  }

  Future<void> retryTransactions() => refreshTransactions();

  Future<void> loadMoreTransactions() async {
    if (!state.hasNextPage || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true, transactionsErrorMessage: null));
    await _loadTransactionsPage(state.currentPage + 1, append: true);
  }

  Future<void> _loadTransactionsPage(int page, {bool append = false}) async {
    final result = await getTransactionsUseCase(
      const EarningsTransactionsParams(
        page: 1,
        pageSize: _pageSize,
      ).copyWith(page: page),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          transactionsStatus: EarningsLoadStatus.failure,
          isLoadingMore: false,
          transactionsErrorMessage: failure.message,
        ),
      ),
      (pageResult) => emit(
        state.copyWith(
          transactionsStatus: EarningsLoadStatus.success,
          transactions: append
              ? [...state.transactions, ...pageResult.items]
              : pageResult.items,
          currentPage: pageResult.page,
          totalPages: pageResult.totalPages,
          hasNextPage: pageResult.hasNextPage,
          isLoadingMore: false,
        ),
      ),
    );
  }
}

extension on EarningsTransactionsParams {
  EarningsTransactionsParams copyWith({int? page, int? pageSize}) {
    return EarningsTransactionsParams(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
