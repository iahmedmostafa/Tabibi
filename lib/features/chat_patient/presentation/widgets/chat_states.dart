import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/constants/app_colors.dart';

/// Shown when the messages list is empty
class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 70.sp,
            color: AppColors.grey300,
          ),
          SizedBox(height: 16.h),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.grey500,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Start the conversation!',
            style: TextStyle(fontSize: 13.sp, color: AppColors.grey400),
          ),
        ],
      ),
    );
  }
}

/// Shown when the network / server call fails
class ChatErrorState extends StatelessWidget {
  const ChatErrorState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 60.sp, color: AppColors.grey400),
          SizedBox(height: 12.h),
          Text(
            'Could not load messages',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Yellow banner shown when canChat == false
class ChatExpiredBanner extends StatelessWidget {
  const ChatExpiredBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(12.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_clock_rounded,
            color: Color(0xFFF59E0B),
            size: 20,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Chat is only available for 7 days after your appointment.',
              style: TextStyle(
                color: const Color(0xFF92400E),
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
