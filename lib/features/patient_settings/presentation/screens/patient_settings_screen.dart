import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class PatientSettingsScreen extends StatelessWidget {
  const PatientSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLocale = context.locale;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'settings'.tr(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left_2,
            color: isDark ? Colors.white : AppColors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey900 : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.12),
                ),
              ),
              child: Column(
                children: [
                  _LanguageTile(
                    icon: Iconsax.global,
                    title: 'language'.tr(),
                    currentLocale: currentLocale,
                    isDark: isDark,
                    onChanged: (locale) {
                      context.setLocale(locale);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Locale currentLocale;
  final bool isDark;
  final ValueChanged<Locale> onChanged;

  const _LanguageTile({
    required this.icon,
    required this.title,
    required this.currentLocale,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.black,
              ),
            ),
          ),
          DropdownButton<Locale>(
            value: currentLocale,
            underline: const SizedBox(),
            dropdownColor: isDark ? AppColors.grey800 : Colors.white,
            items: [
              DropdownMenuItem(
                value: const Locale('en'),
                child: Text('english'.tr()),
              ),
              DropdownMenuItem(
                value: const Locale('ar'),
                child: Text('arabic'.tr()),
              ),
            ],
            onChanged: (locale) {
              if (locale != null) onChanged(locale);
            },
          ),
        ],
      ),
    );
  }
}
