import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class EarningsInlineError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const EarningsInlineError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.red.withValues(alpha: 0.1) : AppColors.lightPink,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? Colors.red.shade900.withValues(alpha: 0.5) : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? Colors.red.shade300 : AppColors.darkRed,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: TextStyle(
                color: isDark ? Colors.red.shade300 : AppColors.midnightBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EarningsEmptyInlineState extends StatelessWidget {
  final String message;

  const EarningsEmptyInlineState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.grey400 : AppColors.grey500,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class EarningsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const EarningsErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: isDark ? Colors.red.shade400 : AppColors.error,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white : AppColors.grey900,
              ),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.midnightBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
