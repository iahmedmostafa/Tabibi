import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/enums/enums.dart';

class BookingTabFilter extends StatelessWidget {
  final BookingStatus selectedTab;
  final Function(BookingStatus) onTabSelected;

  const BookingTabFilter({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTabItem(context, "Upcoming", BookingStatus.upcoming),
          _buildTabItem(context, "Completed", BookingStatus.completed),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    String title,
    BookingStatus status,
  ) {
    final isSelected = selectedTab == status;
    return GestureDetector(
      onTap: () => onTabSelected(status),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.primary : AppColors.grey400,
            ),
          ),
          SizedBox(height: 8.h),
          if (isSelected)
            Container(
              height: 3.h,
              width: 30.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
        ],
      ),
    );
  }
}
