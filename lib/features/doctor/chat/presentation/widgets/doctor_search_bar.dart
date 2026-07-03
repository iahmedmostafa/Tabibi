import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_card.dart';
import 'chat_localizations.dart';

class DoctorSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const DoctorSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = ChatLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: DoctorCard(
        padding: EdgeInsets.zero,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: AppTextStyle.bodySRegular.copyWith(
            color: isDark ? Colors.white : AppColors.grey800,
          ),
          decoration: InputDecoration(
            hintText: loc.search,
            hintStyle: AppTextStyle.bodySRegular.copyWith(
              color: isDark ? AppColors.grey500 : AppColors.grey400,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: isDark ? AppColors.grey400 : AppColors.grey500,
              size: 22.sp,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      controller.clear();
                      onChanged('');
                    },
                    child: Icon(
                      Icons.clear_rounded,
                      color: isDark ? AppColors.grey400 : AppColors.grey500,
                      size: 18.sp,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
          ),
        ),
      ),
    );
  }
}
