import 'package:equatable/equatable.dart';

class EarningsSummary extends Equatable {
  final double totalEarnings;
  final double percentageChange;
  final double thisMonth;
  final double appCommission;
  final int consultations;
  final double avgPerVisit;

  const EarningsSummary({
    required this.totalEarnings,
    required this.percentageChange,
    required this.thisMonth,
    required this.appCommission,
    required this.consultations,
    required this.avgPerVisit,
  });

  @override
  List<Object?> get props => [
    totalEarnings,
    percentageChange,
    thisMonth,
    appCommission,
    consultations,
    avgPerVisit,
  ];
}

class Transaction extends Equatable {
  final String id;
  final String patientName;
  final String type; // Consultation, Procedure
  final DateTime date;
  final double amount;

  const Transaction({
    required this.id,
    required this.patientName,
    required this.type,
    required this.date,
    required this.amount,
  });

  @override
  List<Object?> get props => [id, patientName, type, date, amount];
}

class ChartDataPoint extends Equatable {
  final String label; // Week 1, Week 2, etc.
  final double value;

  const ChartDataPoint({required this.label, required this.value});

  @override
  List<Object?> get props => [label, value];
}
