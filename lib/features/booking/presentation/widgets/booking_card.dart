import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/core/utils/formatters.dart/formatters.dart';
import 'package:tabibi/features/booking/data/models/booking_model.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final BookingStatus status;

  const BookingCard({super.key, required this.booking, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Formatter.formatIsoToDateTime(booking.appointmentDate),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: AppColors.midnightBlue,
                ),
              ),
              status==BookingStatus.completed?
                GestureDetector(
                  onTap: () {
                    context.goNamed(
                      AppRoutes.chat,
                      pathParameters: {'doctorId': booking.doctorId},
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.midnightBlue,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.message,
                          size: 14.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "Chat",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,

            ),                ),
                      ],
                    ),
                  ),
                )
                :const SizedBox.shrink(),
            ],
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
                    image: CachedNetworkImageProvider(booking.doctorAvatar!),
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
                      booking.department,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.grey500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Iconsax.location,
                          size: 14.sp,
                          color: AppColors.grey500,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            booking.address,
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
    if (status == BookingStatus.upcoming) {
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
        ],
      );
    } else {
      return Column(
        children: [
          Row(
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
              if (booking.showPrescriptionButton == true) ...[
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildButton(
                    context,
                    AppStrings.prescription,
                    AppColors.midnightBlue,
                    Colors.white,
                    () {
                      context.goNamed(
                        AppRoutes.prescription,
                        pathParameters: {'bookingId': booking.id},
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
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
