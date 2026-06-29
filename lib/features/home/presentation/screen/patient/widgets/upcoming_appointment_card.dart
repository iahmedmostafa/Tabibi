import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/soft_card_decoration.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/status_pill.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  const UpcomingAppointmentCard({
    super.key,
    required this.booking,
    required this.formattedDate,
    required this.formattedTime,
    required this.countText,
    required this.onTap,
  });

  final dynamic booking;
  final String formattedDate;
  final String formattedTime;
  final String countText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: softCardDecoration(),
        child: Row(
          children: [
            Container(
              width: 78.r,
              height: 78.r,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: booking.doctorAvatar != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: CachedNetworkImage(
                        imageUrl: booking.doctorAvatar!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: AppColors.grey300),
                        errorWidget: (context, url, error) =>
                            const Icon(Iconsax.user, color: AppColors.grey500),
                      ),
                    )
                  : const Icon(Iconsax.user, color: AppColors.grey500),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          booking.doctorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                      StatusPill(
                        text: DoctorAppointmentStatus.label(
                          booking.status ?? DoctorAppointmentStatus.upcoming,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    booking.department,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.grey600,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(
                        Iconsax.calendar_1,
                        color: AppColors.primary,
                        size: 15.sp,
                      ),
                      SizedBox(width: 5.w),
                      Flexible(
                        child: Text(
                          formattedDate,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.grey600,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Icon(
                        Iconsax.clock,
                        color: AppColors.primary,
                        size: 15.sp,
                      ),
                      SizedBox(width: 5.w),
                      Flexible(
                        child: Text(
                          formattedTime,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.grey600,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    countText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.grey500,
                      fontWeight: FontWeight.w600,
                    ),
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
