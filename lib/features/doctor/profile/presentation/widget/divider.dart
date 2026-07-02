import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class DividerWidget extends StatelessWidget {
  final bool? isDark;

  const DividerWidget({super.key, this.isDark});

  @override
  Widget build(BuildContext context) {
    final dark = isDark ?? (Theme.of(context).brightness == Brightness.dark);
    return Divider(
      height: 1.h,
      indent: 60.w,
      endIndent: 16.w,
      color: dark ? AppColors.grey800 : AppColors.grey200,
    );
  }
}
