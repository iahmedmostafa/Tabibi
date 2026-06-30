import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';

/// A reusable confirmation dialog used for destructive actions (logout, remove, etc.)
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final bool isLoading;
  final bool closeOnConfirm;
  final IconData? icon;
  final Color? confirmColor;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.onConfirm,
    this.cancelText = AppStrings.cancel,
    this.isLoading = false,
    this.closeOnConfirm = true,
    this.icon,
    this.confirmColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionColor = confirmColor ?? AppColors.midnightBlue;
    bool isDark = theme.brightness == Brightness.dark;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
      backgroundColor: isDark? AppColors.grey900 : AppColors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 360.w),
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
              if (icon != null) ...[
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: actionColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: actionColor, size: 24.sp),
                ),
                SizedBox(height: 16.h),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                height: 1,
                color: theme.dividerColor.withValues(alpha: 0.55),
            ),
              SizedBox(height: 16.h),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.grey300 : AppColors.grey700,
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: isLoading ? null : () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      minimumSize: Size(0, 44.h),
                      padding: EdgeInsets.symmetric(vertical: AppHeight.h12),
                    ),
                    child: Text(
                      cancelText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.grey300 : AppColors.grey700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppWidth.w12),
                Expanded(
                  child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (closeOnConfirm) Navigator.pop(context);
                              onConfirm();
                            },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: actionColor,
                        disabledBackgroundColor: actionColor.withValues(
                          alpha: 0.65,
                        ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.r),
                      ),
                        elevation: 0,
                        minimumSize: Size(0, 44.h),
                        padding: EdgeInsets.symmetric(vertical: AppHeight.h12),
                    ),
                      child: isLoading
                          ? SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              confirmText,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}
