import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/earnings/domain/entities/earnings.dart';
import 'package:tabibi/features/doctor/earnings/presentation/cubit/earnings_cubit.dart';
import 'package:tabibi/features/doctor/earnings/presentation/cubit/earnings_state.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EarningsCubit(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text('Earnings', style: TextStyle(fontSize: 20.sp)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.file_download_outlined,
                size: 24.sp,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _TotalEarningsCard(),
              SizedBox(height: 16),
              _StatsCards(),
              SizedBox(height: 16),
              _FilterButtons(),
              SizedBox(height: 24),
              _EarningsChart(),
              SizedBox(height: 24),
              _RecentTransactions(),
              SizedBox(height: 80), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }
}

class _TotalEarningsCard extends StatelessWidget {
  const _TotalEarningsCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsCubit, EarningsState>(
      buildWhen: (previous, current) => previous.summary != current.summary,
      builder: (context, state) {
        final summary = state.summary;
        return Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Earnings',
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                '\$${NumberFormat('#,##0').format(summary.totalEarnings)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    color: const Color(0xFF4CAF50),
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '+${summary.percentageChange}% from last month',
                    style: TextStyle(
                      color: const Color(0xFF4CAF50),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'This Month',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '\$${NumberFormat('#,##0').format(summary.thisMonth)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'App Commission',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '-\$${NumberFormat('#,##0').format(summary.appCommission)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatsCards extends StatelessWidget {
  const _StatsCards();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsCubit, EarningsState>(
      buildWhen: (previous, current) => previous.summary != current.summary,
      builder: (context, state) {
        final summary = state.summary;
        return Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.trending_up,
                iconColor: const Color(0xFF4CAF50),
                iconBg: const Color(0xFFE8F5E9),
                label: 'Consultations',
                value: summary.consultations.toString(),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _StatCard(
                icon: Icons.attach_money,
                iconColor: const Color(0xFF2196F3),
                iconBg: const Color(0xFFE3F2FD),
                label: 'Avg. per Visit',
                value: '\$${summary.avgPerVisit.toInt()}',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _FilterButtons extends StatelessWidget {
  const _FilterButtons();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsCubit, EarningsState>(
      buildWhen: (previous, current) =>
          previous.selectedFilter != current.selectedFilter,
      builder: (context, state) {
        return Row(
          children: [
            _FilterButton(
              label: 'Week',
              isSelected: state.selectedFilter == EarningsFilter.week,
              onTap: () =>
                  context.read<EarningsCubit>().setFilter(EarningsFilter.week),
            ),
            SizedBox(width: 12.w),
            _FilterButton(
              label: 'Month',
              isSelected: state.selectedFilter == EarningsFilter.month,
              onTap: () =>
                  context.read<EarningsCubit>().setFilter(EarningsFilter.month),
            ),
            SizedBox(width: 12.w),
            _FilterButton(
              label: 'Year',
              isSelected: state.selectedFilter == EarningsFilter.year,
              onTap: () =>
                  context.read<EarningsCubit>().setFilter(EarningsFilter.year),
            ),
          ],
        );
      },
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2C3E50) : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _EarningsChart extends StatelessWidget {
  const _EarningsChart();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsCubit, EarningsState>(
      buildWhen: (previous, current) => previous.chartData != current.chartData,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Earnings Overview',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                height: 200.h,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1500,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(color: Colors.grey[200]!, strokeWidth: 1);
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40.w,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 10.sp,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < state.chartData.length) {
                              return Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Text(
                                  state.chartData[index].label,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 10.sp,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: state.chartData
                            .asMap()
                            .entries
                            .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                            .toList(),
                        isCurved: true,
                        color: const Color(0xFF2C3E50),
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: const Color(0xFF2C3E50),
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsCubit, EarningsState>(
      buildWhen: (previous, current) =>
          previous.transactions != current.transactions,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'View All',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ...state.transactions.map(
                (transaction) => _TransactionItem(transaction: transaction),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.account_balance_wallet),
                  label: const Text('Withdraw Funds'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3E50),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.attach_money,
              size: 20.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.patientName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${transaction.type} • ${DateFormat('MMM d, yyyy').format(transaction.date)}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            '+\$${transaction.amount.toInt()}',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }
}
