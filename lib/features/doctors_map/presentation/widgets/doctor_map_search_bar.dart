import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class DoctorMapSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const DoctorMapSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.grey900 : AppColors.white;
    final borderColor = isDark ? AppColors.grey700 : AppColors.grey200;
    final hintColor = isDark ? AppColors.grey400 : AppColors.grey500;

    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: AppColors.primary, size: 22.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.white : AppColors.black,
              ),
              decoration: InputDecoration(
                hintText: 'searchDoctors'.tr(),
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: hintColor),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 16.h),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                splashRadius: 20,
                onPressed: onClear,
                icon: Icon(Icons.close_rounded, color: hintColor, size: 20.sp),
              );
            },
          ),
        ],
      ),
    );
  }
}
