import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class MyLocationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double bottomOffset;

  const MyLocationButton({
    super.key,
    required this.onPressed,
    required this.bottomOffset,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.grey900 : AppColors.white;
    final borderColor = isDark ? AppColors.grey700 : AppColors.grey200;
    final iconColor = isDark ? AppColors.white : AppColors.primary;

    return Positioned(
      bottom: bottomOffset,
      right: 16.w,
      child: Material(
        color: background,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.18),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor),
            ),
            child: Icon(Icons.my_location_rounded, color: iconColor, size: 22.sp),
          ),
        ),
      ),
    );
  }
}
