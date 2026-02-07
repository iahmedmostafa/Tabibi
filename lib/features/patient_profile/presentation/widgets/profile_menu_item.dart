import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool isLogout;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppHeight.h16,
          horizontal: AppWidth.w20,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? AppColors.error : AppColors.grey600,
              size: 24.sp,
            ),
            SizedBox(width: AppWidth.w16),
            Expanded(
              child: Text(
                text,
                style: isLogout
                    ? Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(color: AppColors.error)
                    : Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (!isLogout)
              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: AppColors.grey400,
              ),
          ],
        ),
      ),
    );
  }
}
