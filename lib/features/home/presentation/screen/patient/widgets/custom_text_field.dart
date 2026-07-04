import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool? isEnabled;
  final void Function(String)? onChanged;
  final VoidCallback? onFilterTap;
  final bool isFilterActive;
  const CustomTextField({
    required this.controller,
    super.key,
    this.isEnabled,
    this.onChanged,
    this.onFilterTap,
    this.isFilterActive = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.grey900 : AppColors.white;
    final borderColor = isDark ? AppColors.grey700 : AppColors.grey200;

    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.midnightBlue.withValues(alpha: 0.05),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Iconsax.search_normal, color: AppColors.primary, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              enabled: widget.isEnabled ?? true,
              controller: widget.controller,
              onChanged: widget.onChanged,
              autofocus: false,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.white : AppColors.black,
              ),
              decoration: InputDecoration(
                hintText: 'searchByName'.tr(),
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.grey400 : AppColors.grey500,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 18.h),
              ),
            ),
          ),
          if (widget.onFilterTap != null) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: widget.onFilterTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
