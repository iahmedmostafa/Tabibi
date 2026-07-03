import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class DocumentsCard extends StatelessWidget {
  const DocumentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.grey800 : AppColors.grey200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Documents & Scans',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.grey900,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  color: AppColors.midnightBlue,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDocumentPlaceholder(context, Icons.image_outlined),
                SizedBox(width: 12.w),
                _buildDocumentPlaceholder(context, Icons.description_outlined),
                SizedBox(width: 12.w),
                _buildAddDocument(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentPlaceholder(BuildContext context, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey800 : Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        icon,
        size: 40.sp,
        color: isDark ? AppColors.grey400 : Colors.grey[400],
      ),
    );
  }

  Widget _buildAddDocument(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.grey800 : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Icon(
        Icons.add,
        size: 40.sp,
        color: isDark ? AppColors.grey400 : Colors.grey[400],
      ),
    );
  }
}
