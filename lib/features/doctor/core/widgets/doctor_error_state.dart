import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';

class DoctorErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const DoctorErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = DoctorLocalizations.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.grey800
                    : AppColors.error.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 64.sp,
                color: isDark ? AppColors.error : AppColors.error,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.grey300 : AppColors.grey600,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: 24.h),
              SizedBox(
                height: 48.h,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: Icon(Icons.refresh_rounded, size: 18.sp),
                  label: Text(
                    loc.retry,
                    style: theme.textTheme.labelLarge,
                  ),
                  style: theme.elevatedButtonTheme.style?.copyWith(
                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                      horizontal: 24.w,
                    )),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
