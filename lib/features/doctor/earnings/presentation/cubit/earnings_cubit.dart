import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/doctor/earnings/domain/entities/earnings.dart';
import 'earnings_state.dart';

class EarningsCubit extends Cubit<EarningsState> {
  EarningsCubit()
    : super(
        EarningsState(
          summary: const EarningsSummary(
            totalEarnings: 12500,
            percentageChange: 18.5,
            thisMonth: 4200,
            appCommission: 420,
            consultations: 48,
            avgPerVisit: 156,
          ),
          transactions: _mockTransactions,
          chartData: _mockMonthChartData,
        ),
      );

  static final List<Transaction> _mockTransactions = [
    Transaction(
      id: '1',
      patientName: 'Sarah Johnson',
      type: 'Consultation',
      date: DateTime(2025, 11, 21),
      amount: 150,
    ),
    Transaction(
      id: '2',
      patientName: 'Michael Chen',
      type: 'Consultation',
      date: DateTime(2025, 11, 21),
      amount: 120,
    ),
    Transaction(
      id: '3',
      patientName: 'Emily Parker',
      type: 'Procedure',
      date: DateTime(2025, 11, 20),
      amount: 200,
    ),
    Transaction(
      id: '4',
      patientName: 'James Wilson',
      type: 'Consultation',
      date: DateTime(2025, 11, 20),
      amount: 150,
    ),
    Transaction(
      id: '5',
      patientName: 'Lisa Anderson',
      type: 'Consultation',
      date: DateTime(2025, 11, 19),
      amount: 180,
    ),
  ];

  static const List<ChartDataPoint> _mockWeekChartData = [
    ChartDataPoint(label: 'Mon', value: 200),
    ChartDataPoint(label: 'Tue', value: 350),
    ChartDataPoint(label: 'Wed', value: 280),
    ChartDataPoint(label: 'Thu', value: 420),
    ChartDataPoint(label: 'Fri', value: 380),
    ChartDataPoint(label: 'Sat', value: 150),
    ChartDataPoint(label: 'Sun', value: 100),
  ];

  static const List<ChartDataPoint> _mockMonthChartData = [
    ChartDataPoint(label: 'Week 1', value: 2500),
    ChartDataPoint(label: 'Week 2', value: 3200),
    ChartDataPoint(label: 'Week 3', value: 2800),
    ChartDataPoint(label: 'Week 4', value: 4200),
  ];

  static const List<ChartDataPoint> _mockYearChartData = [
    ChartDataPoint(label: 'Jan', value: 8500),
    ChartDataPoint(label: 'Feb', value: 9200),
    ChartDataPoint(label: 'Mar', value: 10500),
    ChartDataPoint(label: 'Apr', value: 9800),
    ChartDataPoint(label: 'May', value: 11200),
    ChartDataPoint(label: 'Jun', value: 10800),
    ChartDataPoint(label: 'Jul', value: 12000),
    ChartDataPoint(label: 'Aug', value: 11500),
    ChartDataPoint(label: 'Sep', value: 13000),
    ChartDataPoint(label: 'Oct', value: 12200),
    ChartDataPoint(label: 'Nov', value: 12500),
    ChartDataPoint(label: 'Dec', value: 14000),
  ];

  void setFilter(EarningsFilter filter) {
    List<ChartDataPoint> newChartData;

    switch (filter) {
      case EarningsFilter.week:
        newChartData = _mockWeekChartData;
        break;
      case EarningsFilter.month:
        newChartData = _mockMonthChartData;
        break;
      case EarningsFilter.year:
        newChartData = _mockYearChartData;
        break;
    }

    emit(state.copyWith(selectedFilter: filter, chartData: newChartData));
  }
}
