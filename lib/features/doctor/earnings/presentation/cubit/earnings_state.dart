import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor/earnings/domain/entities/earnings.dart';

enum EarningsLoadStatus { initial, loading, success, failure }

class EarningsState extends Equatable {
  final EarningsLoadStatus status;
  final EarningsLoadStatus analyticsStatus;
  final EarningsLoadStatus transactionsStatus;
  final EarningsSummary? summary;
  final List<ChartDataPoint> chartData;
  final EarningsPeriod selectedPeriod;
  final List<EarningsTransaction> transactions;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool isLoadingMore;
  final String? errorMessage;
  final String? analyticsErrorMessage;
  final String? transactionsErrorMessage;

  const EarningsState({
    this.status = EarningsLoadStatus.initial,
    this.analyticsStatus = EarningsLoadStatus.initial,
    this.transactionsStatus = EarningsLoadStatus.initial,
    this.summary,
    this.chartData = const [],
    this.selectedPeriod = EarningsPeriod.week,
    this.transactions = const [],
    this.currentPage = 0,
    this.totalPages = 0,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.analyticsErrorMessage,
    this.transactionsErrorMessage,
  });

  EarningsState copyWith({
    EarningsLoadStatus? status,
    EarningsLoadStatus? analyticsStatus,
    EarningsLoadStatus? transactionsStatus,
    EarningsSummary? summary,
    List<ChartDataPoint>? chartData,
    EarningsPeriod? selectedPeriod,
    List<EarningsTransaction>? transactions,
    int? currentPage,
    int? totalPages,
    bool? hasNextPage,
    bool? isLoadingMore,
    String? errorMessage,
    String? analyticsErrorMessage,
    String? transactionsErrorMessage,
  }) {
    return EarningsState(
      status: status ?? this.status,
      analyticsStatus: analyticsStatus ?? this.analyticsStatus,
      transactionsStatus: transactionsStatus ?? this.transactionsStatus,
      summary: summary ?? this.summary,
      chartData: chartData ?? this.chartData,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      transactions: transactions ?? this.transactions,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      analyticsErrorMessage: analyticsErrorMessage,
      transactionsErrorMessage: transactionsErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    analyticsStatus,
    transactionsStatus,
    summary,
    chartData,
    selectedPeriod,
    transactions,
    currentPage,
    totalPages,
    hasNextPage,
    isLoadingMore,
    errorMessage,
    analyticsErrorMessage,
    transactionsErrorMessage,
  ];
}
