import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/earnings/domain/entities/earnings.dart';
import 'package:tabibi/features/doctor/earnings/presentation/cubit/earnings_cubit.dart';
import 'package:tabibi/features/doctor/earnings/presentation/cubit/earnings_state.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EarningsCubit>()..loadDashboard(),
      child: Scaffold(
        backgroundColor: AppColors.grey50,
        appBar: AppBar(
          title: Text(
            'Earnings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.grey900,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<EarningsCubit, EarningsState>(
          builder: (context, state) {
            if (state.status == EarningsLoadStatus.loading &&
                state.summary == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == EarningsLoadStatus.failure &&
                state.summary == null) {
              return _ErrorState(
                message: state.errorMessage ?? 'Failed to load earnings.',
                onRetry: () => context.read<EarningsCubit>().loadDashboard(),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<EarningsCubit>().loadDashboard(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
                child: Column(
                  children: [
                    _HeroSummaryCard(summary: state.summary!),
                    SizedBox(height: 14.h),
                    _SummaryGrid(summary: state.summary!),
                    SizedBox(height: 18.h),
                    const _AnalyticsSection(),
                    SizedBox(height: 18.h),
                    const _TransactionsSection(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeroSummaryCard extends StatelessWidget {
  final EarningsSummary summary;

  const _HeroSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final growthPositive = summary.growthPercentage >= 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.midnightBlue,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.midnightBlue.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lifetime Earnings',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _money(summary.totalLifetimeEarnings),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _HeroChip(
                icon: growthPositive ? Icons.trending_up : Icons.trending_down,
                label:
                    '${growthPositive ? '+' : ''}${summary.growthPercentage.toStringAsFixed(1)}% growth',
              ),
              _HeroChip(
                icon: Icons.calendar_month_outlined,
                label: '${_money(summary.thisMonthEarnings)} this month',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15.sp, color: Colors.white70),
          SizedBox(width: 6.w),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  final EarningsSummary summary;

  const _SummaryGrid({required this.summary});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _MetricData(
        'This Month',
        _money(summary.thisMonthEarnings),
        Icons.today,
        AppColors.teal,
      ),
      _MetricData(
        'Commission',
        _money(summary.appCommission),
        Icons.percent_rounded,
        AppColors.orange,
      ),
      _MetricData(
        'Growth',
        '${summary.growthPercentage.toStringAsFixed(1)}%',
        Icons.trending_up,
        AppColors.green,
      ),
      _MetricData(
        'Consultations',
        summary.totalConsultations.toString(),
        Icons.groups_outlined,
        AppColors.blue,
      ),
      _MetricData(
        'Average / Visit',
        _money(summary.averagePerVisit),
        Icons.payments_outlined,
        AppColors.purple,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) => _MetricCard(data: cards[index]),
    );
  }
}

class _MetricData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricData(this.label, this.value, this.icon, this.color);
}

class _MetricCard extends StatelessWidget {
  final _MetricData data;

  const _MetricCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(data.icon, color: data.color, size: 20.sp),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                data.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.grey900,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnalyticsSection extends StatelessWidget {
  const _AnalyticsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsCubit, EarningsState>(
      buildWhen: (previous, current) =>
          previous.chartData != current.chartData ||
          previous.selectedPeriod != current.selectedPeriod ||
          previous.analyticsStatus != current.analyticsStatus,
      builder: (context, state) {
        return _DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader(
                title: 'Analytics',
                subtitle: 'Revenue trend by selected period',
                icon: Icons.show_chart,
              ),
              SizedBox(height: 16.h),
              _PeriodTabs(selected: state.selectedPeriod),
              SizedBox(height: 18.h),
              if (state.analyticsStatus == EarningsLoadStatus.loading)
                SizedBox(
                  height: 220.h,
                  child: const Center(child: CircularProgressIndicator()),
                )
              else if (state.analyticsStatus == EarningsLoadStatus.failure)
                _InlineError(
                  message:
                      state.analyticsErrorMessage ?? 'Failed to load chart.',
                  onRetry: () => context.read<EarningsCubit>().loadAnalytics(
                    state.selectedPeriod,
                  ),
                )
              else if (state.chartData.isEmpty)
                const _EmptyInlineState(message: 'No analytics data yet.')
              else
                _Chart(data: state.chartData),
            ],
          ),
        );
      },
    );
  }
}

class _PeriodTabs extends StatelessWidget {
  final EarningsPeriod selected;

  const _PeriodTabs({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: EarningsPeriod.values.map((period) {
        final isSelected = selected == period;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: period == EarningsPeriod.year ? 0 : 8.w,
            ),
            child: InkWell(
              onTap: () => context.read<EarningsCubit>().loadAnalytics(period),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 11.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.midnightBlue
                      : AppColors.grey100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  _periodLabel(period),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected ? Colors.white : AppColors.grey600,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Chart extends StatelessWidget {
  final List<ChartDataPoint> data;

  const _Chart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxAmount = data.fold<double>(
      0,
      (previous, point) => math.max(previous, point.amount),
    );
    final chartMaxY = maxAmount <= 0 ? 100.0 : maxAmount * 1.25;

    return SizedBox(
      height: 240.h,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: chartMaxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: chartMaxY / 4,
            getDrawingHorizontalLine: (value) {
              return const FlLine(color: AppColors.grey200, strokeWidth: 1);
            },
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 46.w,
                getTitlesWidget: (value, meta) => Text(
                  _compactMoney(value),
                  style: TextStyle(color: AppColors.grey500, fontSize: 10.sp),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      data[index].label,
                      style: TextStyle(
                        color: AppColors.grey500,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: data
                  .asMap()
                  .entries
                  .map(
                    (entry) => FlSpot(entry.key.toDouble(), entry.value.amount),
                  )
                  .toList(),
              isCurved: true,
              color: AppColors.teal,
              barWidth: 4,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.teal,
                    strokeWidth: 3,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.teal.withValues(alpha: 0.10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionsSection extends StatelessWidget {
  const _TransactionsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsCubit, EarningsState>(
      buildWhen: (previous, current) =>
          previous.transactions != current.transactions ||
          previous.transactionsStatus != current.transactionsStatus ||
          previous.hasNextPage != current.hasNextPage ||
          previous.isLoadingMore != current.isLoadingMore,
      builder: (context, state) {
        return _DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader(
                title: 'Recent Transactions',
                subtitle: 'Completed visit payments',
                icon: Icons.receipt_long_outlined,
              ),
              SizedBox(height: 16.h),
              if (state.transactionsStatus == EarningsLoadStatus.loading)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.transactionsStatus == EarningsLoadStatus.failure &&
                  state.transactions.isEmpty)
                _InlineError(
                  message:
                      state.transactionsErrorMessage ??
                      'Failed to load transactions.',
                  onRetry: () =>
                      context.read<EarningsCubit>().refreshTransactions(),
                )
              else if (state.transactions.isEmpty)
                const _EmptyInlineState(message: 'No transactions yet.')
              else ...[
                ...state.transactions.map(
                  (transaction) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _TransactionCard(transaction: transaction),
                  ),
                ),
                if (state.hasNextPage)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: state.isLoadingMore
                          ? null
                          : () => context
                                .read<EarningsCubit>()
                                .loadMoreTransactions(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 13.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: state.isLoadingMore
                          ? SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Load More'),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final EarningsTransaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final hasAvatar =
        transaction.patientAvatarUrl != null &&
        transaction.patientAvatarUrl!.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              width: 48.w,
              height: 48.w,
              color: AppColors.grey100,
              child: hasAvatar
                  ? CachedNetworkImage(
                      imageUrl: transaction.patientAvatarUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const Icon(Icons.person),
                    )
                  : Icon(Icons.person, color: AppColors.grey500, size: 24.sp),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.patientName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey900,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${transaction.type} • ${DateFormat('MMM d, yyyy').format(transaction.date)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            '+${_money(transaction.pricePaid)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final Widget child;

  const _DashboardCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: AppColors.teal.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13.r),
          ),
          child: Icon(icon, color: AppColors.teal, size: 22.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.grey900,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.grey500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InlineError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.darkRed,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EmptyInlineState extends StatelessWidget {
  final String message;

  const _EmptyInlineState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.grey500,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: AppColors.error),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 12.h),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

String _periodLabel(EarningsPeriod period) {
  switch (period) {
    case EarningsPeriod.week:
      return 'Week';
    case EarningsPeriod.month:
      return 'Month';
    case EarningsPeriod.year:
      return 'Year';
  }
}

String _money(double amount) {
  return NumberFormat.currency(symbol: r'$', decimalDigits: 0).format(amount);
}

String _compactMoney(double amount) {
  if (amount >= 1000000) {
    return '\$${(amount / 1000000).toStringAsFixed(1)}M';
  }
  if (amount >= 1000) {
    return '\$${(amount / 1000).toStringAsFixed(0)}K';
  }
  return '\$${amount.toStringAsFixed(0)}';
}
