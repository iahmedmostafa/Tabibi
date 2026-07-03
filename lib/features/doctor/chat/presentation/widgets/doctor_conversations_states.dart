import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_error_state.dart';
import 'chat_localizations.dart';

class DoctorConversationsEmptyState extends StatelessWidget {
  const DoctorConversationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = ChatLocalizations.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface
                    : AppColors.midnightBlue.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 64.sp,
                color: isDark ? AppColors.grey600 : AppColors.midnightBlue.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              loc.noChats,
              style: AppTextStyle.h2.copyWith(
                color: isDark ? Colors.white : AppColors.grey800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              loc.noChatsDesc,
              style: AppTextStyle.bodySRegular.copyWith(
                color: isDark ? AppColors.grey400 : AppColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorConversationsErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const DoctorConversationsErrorState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final loc = ChatLocalizations.of(context);

    return DoctorErrorState(
      message: loc.failedLoad,
      onRetry: onRetry,
    );
  }
}
