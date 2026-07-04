import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_card.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_section_header.dart';

class LanguageSection extends StatelessWidget {
  const LanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = DoctorLocalizations.of(context);
    final currentLocale = context.locale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: DoctorSectionHeader(title: loc.language),
        ),
        SizedBox(height: 12.h),
        DoctorCard(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.grey800 : AppColors.grey100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Iconsax.global,
                  color: isDark ? AppColors.grey300 : AppColors.grey600,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  loc.language,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.grey900,
                  ),
                ),
              ),
              DropdownButton<Locale>(
                value: currentLocale,
                underline: const SizedBox(),
                dropdownColor: isDark ? AppColors.grey800 : Colors.white,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
                items: [
                  DropdownMenuItem(
                    value: const Locale('en'),
                    child: Text(loc.english),
                  ),
                  DropdownMenuItem(
                    value: const Locale('ar'),
                    child: Text(loc.arabic),
                  ),
                ],
                onChanged: (locale) {
                  if (locale != null) context.setLocale(locale);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
