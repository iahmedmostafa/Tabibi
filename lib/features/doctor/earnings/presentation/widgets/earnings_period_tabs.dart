import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/earnings/domain/entities/earnings.dart';
import 'package:tabibi/features/doctor/earnings/presentation/cubit/earnings_cubit.dart';
import 'package:tabibi/features/doctor/earnings/presentation/utils/earnings_formatters.dart';

class EarningsPeriodTabs extends StatelessWidget {
  final EarningsPeriod selected;

  const EarningsPeriodTabs({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: EarningsPeriod.values.map((period) {
        final isSelected = selected == period;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: period == EarningsPeriod.year ? 0 : 8.w,
            ),
            child: InkWell(
              onTap: () =>
                  context.read<EarningsCubit>().selectAnalyticsPeriod(period),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 11.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.midnightBlue
                      : (isDark ? AppColors.grey800 : AppColors.grey100),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  EarningsFormatters.periodLabel(period),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.grey400 : AppColors.grey600),
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
