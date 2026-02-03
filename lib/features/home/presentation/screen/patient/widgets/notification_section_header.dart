import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';

class NotificationSectionHeader extends StatelessWidget {
  final String title;

  const NotificationSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.grey500,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (title == AppStrings.today)
          Text(
            AppStrings.markAllAsRead,
            style: TextStyle(
              color: AppColors.midnightBlue,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
