import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class ErrorPanel extends StatelessWidget {
  const ErrorPanel({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return _StatePanel(
      icon: Iconsax.warning_2,
      message: message,
      accentColor: AppColors.error,
    );
  }
}

class EmptyPanel extends StatelessWidget {
  const EmptyPanel({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return _StatePanel(
      icon: Iconsax.folder_open,
      message: message,
      accentColor: AppColors.primary,
    );
  }
}

class _StatePanel extends StatelessWidget {
  const _StatePanel({
    required this.icon,
    required this.message,
    required this.accentColor,
  });

  final IconData icon;
  final String message;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, color: accentColor, size: 23.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: accentColor == AppColors.error
                        ? AppColors.error
                        : AppColors.grey600,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
