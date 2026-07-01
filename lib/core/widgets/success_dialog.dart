import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.grey900 : AppColors.white;
    final titleColor = theme.colorScheme.onSurface;
    final bodyColor = isDark ? AppColors.grey300 : AppColors.grey600;
    final accentColor = isDark ? AppColors.teal20 : AppColors.lightTeal;
    final accentRingColor = isDark ? AppColors.teal80 : AppColors.actionGreenLight;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.w32,
          vertical: AppHeight.h32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: accentRingColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: surfaceColor, size: 30),
                ),
              ),
            ),
            VerticalSpace(height: AppHeight.h24),
            Text(
              'Congratulations!',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            VerticalSpace(height: AppHeight.h16),
            Text(
              'Your account is ready to use. You will be redirected to the Home Page in a few seconds...',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: bodyColor),
            ),
            VerticalSpace(height: AppHeight.h24),
            CupertinoActivityIndicator(
              radius: 15,
              color: isDark ? AppColors.grey300 : AppColors.grey700,
            ),
          ],
        ),
      ),
    );
  }
}
