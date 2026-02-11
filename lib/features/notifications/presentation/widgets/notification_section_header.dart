import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';

class NotificationSectionHeader extends StatelessWidget {
  final String title;
  final Function()? onMarkAllAsRead;

  const NotificationSectionHeader({
    super.key,
    required this.title,
    this.onMarkAllAsRead,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
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
          TextButton(
            onPressed: onMarkAllAsRead,
            child: Text(
              AppStrings.markAllAsRead,
              style: TextStyle(
                color: isDark?AppColors.white: AppColors.midnightBlue,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
