import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/chat/presentation/widgets/chat_localizations.dart';


class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = ChatLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 70.sp,
            color: isDark ? AppColors.grey700 : AppColors.grey300,
          ),
          SizedBox(height: 16.h),
          Text(
            loc.noMessages,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.grey200 : AppColors.grey500,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            loc.startConversation,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? AppColors.grey400 : AppColors.grey400,
            ),
          ),
        ],
      ),
    );
  }
}


class ChatErrorState extends StatelessWidget {
  const ChatErrorState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = ChatLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 60.sp,
            color: isDark ? AppColors.grey700 : AppColors.grey400,
          ),
          SizedBox(height: 12.h),
          Text(
            loc.couldNotLoadMessages,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.grey300 : AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}


class ChatExpiredBanner extends StatelessWidget {
  const ChatExpiredBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = ChatLocalizations.of(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(12.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey900 : const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.grey800 : const Color(0xFFFFE082),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_clock_rounded,
            color: isDark ? AppColors.actionAmber : const Color(0xFFF59E0B),
            size: 20,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              loc.expiredBanner,
              style: TextStyle(
                color: isDark ? AppColors.grey300 : const Color(0xFF92400E),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
