import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_loading_state.dart';
import 'package:tabibi/features/doctor/earnings/presentation/cubit/earnings_cubit.dart';
import 'package:tabibi/features/doctor/earnings/presentation/cubit/earnings_state.dart';
import 'package:tabibi/features/doctor/earnings/presentation/widgets/earnings_analytics_section.dart';
import 'package:tabibi/features/doctor/earnings/presentation/widgets/earnings_inline_states.dart';
import 'package:tabibi/features/doctor/earnings/presentation/widgets/earnings_summary_cards.dart';
import 'package:tabibi/features/doctor/earnings/presentation/widgets/earnings_transactions_section.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => sl<EarningsCubit>()..loadDashboard(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Earnings', style: theme.textTheme.titleLarge),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<EarningsCubit, EarningsState>(
          builder: (context, state) {
            if (state.isInitialDashboardLoading) {
              return const DoctorLoadingState();
            }

            if (state.hasInitialDashboardFailure) {
              return EarningsErrorState(
                message: state.errorMessage ?? 'Failed to load earnings.',
                onRetry: context.read<EarningsCubit>().retryDashboard,
              );
            }

            final summary = state.summary;
            if (summary == null) {
              return const SizedBox.shrink();
            }

            return RefreshIndicator(
              onRefresh: context.read<EarningsCubit>().retryDashboard,
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
                child: Column(
                  children: [
                    EarningsHeroSummaryCard(summary: summary),
                    SizedBox(height: 14.h),
                    EarningsSummaryGrid(summary: summary),
                    SizedBox(height: 18.h),
                    const EarningsAnalyticsSection(),
                    SizedBox(height: 18.h),
                    const EarningsTransactionsSection(),
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
