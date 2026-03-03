import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor/earnings/domain/entities/earnings.dart';

enum EarningsFilter { week, month, year }

class EarningsState extends Equatable {
  final EarningsSummary summary;
  final List<Transaction> transactions;
  final List<ChartDataPoint> chartData;
  final EarningsFilter selectedFilter;

  const EarningsState({
    required this.summary,
    required this.transactions,
    required this.chartData,
    this.selectedFilter = EarningsFilter.month,
  });

  EarningsState copyWith({
    EarningsSummary? summary,
    List<Transaction>? transactions,
    List<ChartDataPoint>? chartData,
    EarningsFilter? selectedFilter,
  }) {
    return EarningsState(
      summary: summary ?? this.summary,
      transactions: transactions ?? this.transactions,
      chartData: chartData ?? this.chartData,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [summary, transactions, chartData, selectedFilter];
}
