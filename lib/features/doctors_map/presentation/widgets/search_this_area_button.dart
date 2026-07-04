import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchThisAreaButton extends StatelessWidget {
  final VoidCallback onTap;

  const SearchThisAreaButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.grey900 : AppColors.white;
    final border = isDark ? AppColors.grey700 : AppColors.grey200;
    final textColor = isDark ? AppColors.white : AppColors.black;

    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: surface,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.32 : 0.12),
        borderRadius: BorderRadius.circular(999.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(999.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.refresh_rounded,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'searchThisArea'.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
