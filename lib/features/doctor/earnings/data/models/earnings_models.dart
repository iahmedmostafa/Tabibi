import 'package:tabibi/features/doctor/earnings/domain/entities/earnings.dart';

class EarningsSummaryModel extends EarningsSummary {
  const EarningsSummaryModel({
    required super.totalLifetimeEarnings,
    required super.thisMonthEarnings,
    required super.appCommission,
    required super.growthPercentage,
    required super.totalConsultations,
    required super.averagePerVisit,
    required super.weeklyChartData,
  });

  factory EarningsSummaryModel.fromJson(Map<String, dynamic> json) {
    return EarningsSummaryModel(
      totalLifetimeEarnings: _toDouble(json['totalLifetimeEarnings']),
      thisMonthEarnings: _toDouble(json['thisMonthEarnings']),
      appCommission: _toDouble(json['appCommission']),
      growthPercentage: _toDouble(json['growthPercentage']),
      totalConsultations: _toInt(json['totalConsultations']),
      averagePerVisit: _toDouble(json['averagePerVisit']),
      weeklyChartData: (json['weeklyChartData'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ChartDataPointModel.fromJson)
          .toList(),
    );
  }
}

class ChartDataPointModel extends ChartDataPoint {
  const ChartDataPointModel({required super.label, required super.amount});

  factory ChartDataPointModel.fromJson(Map<String, dynamic> json) {
    return ChartDataPointModel(
      label: json['label']?.toString() ?? '',
      amount: _toDouble(json['amount']),
    );
  }
}

class EarningsTransactionModel extends EarningsTransaction {
  const EarningsTransactionModel({
    required super.id,
    required super.patientName,
    super.patientAvatarUrl,
    required super.date,
    required super.pricePaid,
    required super.type,
  });

  factory EarningsTransactionModel.fromJson(Map<String, dynamic> json) {
    return EarningsTransactionModel(
      id: json['id']?.toString() ?? '',
      patientName: json['patientName']?.toString() ?? 'Unknown patient',
      patientAvatarUrl: json['patientAvatarUrl']?.toString(),
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      pricePaid: _toDouble(json['pricePaid']),
      type: json['type']?.toString() ?? 'Consultation',
    );
  }
}

class EarningsTransactionsPageModel extends EarningsTransactionsPage {
  const EarningsTransactionsPageModel({
    required super.items,
    required super.page,
    required super.pageSize,
    required super.totalCount,
    required super.totalPages,
    required super.hasPreviousPage,
    required super.hasNextPage,
  });

  factory EarningsTransactionsPageModel.fromJson(Map<String, dynamic> json) {
    return EarningsTransactionsPageModel(
      items: (json['items'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(EarningsTransactionModel.fromJson)
          .toList(),
      page: _toInt(json['page']),
      pageSize: _toInt(json['pageSize']),
      totalCount: _toInt(json['totalCount']),
      totalPages: _toInt(json['totalPages']),
      hasPreviousPage: json['hasPreviousPage'] == true,
      hasNextPage: json['hasNextPage'] == true,
    );
  }
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
