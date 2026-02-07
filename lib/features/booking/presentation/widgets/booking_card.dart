import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/booking/domain/entities/booking.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${booking.date} - ${booking.time}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: AppColors.midnightBlue,
            ),
          ),
          SizedBox(height: 12.h),
          Container(height: 1, color: AppColors.grey100),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: AppColors.grey100,
                  image: DecorationImage(
                    image: NetworkImage(booking.doctorImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.doctorName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.midnightBlue,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      booking.speciality,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.grey500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14.sp,
                          color: AppColors.grey500,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            booking.location,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.grey500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(height: 1, color: AppColors.grey100),
          SizedBox(height: 16.h),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (booking.status == BookingStatus.upcoming) {
      return Row(
        children: [
          Expanded(
            child: _buildButton(
              context,
              "Cancel",
              AppColors.grey100,
              AppColors.midnightBlue,
              () {},
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildButton(
              context,
              "Reschedule",
              AppColors.midnightBlue,
              Colors.white,
              () {},
            ),
          ),
        ],
      );
    } else if (booking.status == BookingStatus.completed) {
      return Row(
        children: [
          Expanded(
            child: _buildButton(
              context,
              "Re-Book",
              AppColors.grey100,
              AppColors.midnightBlue,
              () {},
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildButton(
              context,
              "Add Review",
              AppColors.midnightBlue,
              Colors.white,
              () {},
            ),
          ),
        ],
      );
    } else {
      // Canceled - For now maybe just Re-Book? Or nothing per design
      return SizedBox(
        width: double.infinity,
        child: _buildButton(
          context,
          "Re-Book",
          AppColors.grey100,
          AppColors.midnightBlue,
          () {},
        ),
      );
    }
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}
