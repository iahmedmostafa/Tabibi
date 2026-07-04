import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/features/doctor/earnings/presentation/cubit/earnings_cubit.dart';
import 'package:tabibi/features/doctor/earnings/presentation/cubit/earnings_state.dart';
import 'package:tabibi/features/doctor/earnings/presentation/widgets/earnings_chart.dart';
import 'package:tabibi/features/doctor/earnings/presentation/widgets/earnings_dashboard_card.dart';
import 'package:tabibi/features/doctor/earnings/presentation/widgets/earnings_inline_states.dart';
import 'package:tabibi/features/doctor/earnings/presentation/widgets/earnings_period_tabs.dart';
import 'package:tabibi/features/doctor/earnings/presentation/widgets/earnings_section_header.dart';
import 'package:easy_localization/easy_localization.dart';

class EarningsAnalyticsSection extends StatelessWidget {
  const EarningsAnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsCubit, EarningsState>(
      buildWhen: (previous, current) =>
          previous.chartData != current.chartData ||
          previous.selectedPeriod != current.selectedPeriod ||
          previous.analyticsStatus != current.analyticsStatus,
      builder: (context, state) {
        return EarningsDashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EarningsSectionHeader(
                title: 'analytics'.tr(),
                subtitle: 'revenueTrend'.tr(),
                icon: Icons.show_chart,
              ),
              SizedBox(height: 16.h),
              EarningsPeriodTabs(selected: state.selectedPeriod),
              SizedBox(height: 18.h),
              if (state.isAnalyticsLoading)
                SizedBox(
                  height: 220.h,
                  child: const Center(child: CircularProgressIndicator()),
                )
              else if (state.hasAnalyticsFailure)
                EarningsInlineError(
                  message:
                      state.analyticsErrorMessage ?? 'failedToLoadChart'.tr(),
                  onRetry: context.read<EarningsCubit>().retryAnalytics,
                )
              else if (state.chartData.isEmpty)
                EarningsEmptyInlineState(message: 'noAnalyticsData'.tr())
              else
                EarningsChart(data: state.chartData),
            ],
          ),
        );
      },
    );
  }
}
