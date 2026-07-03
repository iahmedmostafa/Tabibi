import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class DoctorInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DoctorInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppColors.grey400,
        ),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.grey400 : AppColors.grey500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.white : AppColors.grey900,
            ),
          ),
        ),
      ],
    );
  }
}
