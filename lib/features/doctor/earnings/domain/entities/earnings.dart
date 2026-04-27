import 'package:equatable/equatable.dart';

enum EarningsPeriod { week, month, year }

class EarningsSummary extends Equatable {
  final double totalLifetimeEarnings;
  final double thisMonthEarnings;
  final double appCommission;
  final double growthPercentage;
  final int totalConsultations;
  final double averagePerVisit;
  final List<ChartDataPoint> weeklyChartData;

  const EarningsSummary({
    required this.totalLifetimeEarnings,
    required this.thisMonthEarnings,
    required this.appCommission,
    required this.growthPercentage,
    required this.totalConsultations,
    required this.averagePerVisit,
    required this.weeklyChartData,
  });

  @override
  List<Object?> get props => [
    totalLifetimeEarnings,
    thisMonthEarnings,
    appCommission,
    growthPercentage,
    totalConsultations,
    averagePerVisit,
    weeklyChartData,
  ];
}

class ChartDataPoint extends Equatable {
  final String label;
  final double amount;

  const ChartDataPoint({required this.label, required this.amount});

  @override
  List<Object?> get props => [label, amount];
}

class EarningsTransaction extends Equatable {
  final String id;
  final String patientName;
  final String? patientAvatarUrl;
  final DateTime date;
  final double pricePaid;
  final String type;

  const EarningsTransaction({
    required this.id,
    required this.patientName,
    this.patientAvatarUrl,
    required this.date,
    required this.pricePaid,
    required this.type,
  });

  @override
  List<Object?> get props => [
    id,
    patientName,
    patientAvatarUrl,
    date,
    pricePaid,
    type,
  ];
}

class EarningsTransactionsPage extends Equatable {
  final List<EarningsTransaction> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const EarningsTransactionsPage({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [
    items,
    page,
    pageSize,
    totalCount,
    totalPages,
    hasPreviousPage,
    hasNextPage,
  ];
}
