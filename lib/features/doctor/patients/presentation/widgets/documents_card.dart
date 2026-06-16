import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/theme/theme.dart';

class DocumentsCard extends StatelessWidget {
  const DocumentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.dividerColor),
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
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(color: AppTheme.primaryColor, fontSize: 14.sp),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDocumentPlaceholder(Icons.image_outlined, context),
                SizedBox(width: 12.w),
                _buildDocumentPlaceholder(Icons.description_outlined, context),
                SizedBox(width: 12.w),
                _buildAddDocument(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentPlaceholder(IconData icon, BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        icon,
        size: 40.sp,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildAddDocument(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerColor, width: 2),
      ),
      child: Icon(
        Icons.add,
        size: 40.sp,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
