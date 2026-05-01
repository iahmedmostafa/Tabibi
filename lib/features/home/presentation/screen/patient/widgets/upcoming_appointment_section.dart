import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/helper/backend_date_time.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/core/utils/formatters.dart/formatters.dart';
import 'package:tabibi/features/booking/presentation/controller/upcoming_booking_cubit.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/home_feedback_panel.dart';

class UpcomingAppointmentSection extends StatelessWidget {
  const UpcomingAppointmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpcomingBookingCubit, UpcomingBookingState>(
      builder: (context, state) {
        if (state.status == UpcomingBookingStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == UpcomingBookingStatus.failure) {
          return ErrorPanel(
            message:
                state.errorMessage ?? 'Failed to load upcoming appointment',
          );
        }

        final summary = state.summary;
        final booking = summary?.nextBooking;
        if (summary == null || booking == null) {
          final surfaceColor = Theme.of(context).cardColor;

          return InkWell(
            onTap: () => context.pushNamed(
              AppRoutes.myBookings,
              extra: BookingStatus.upcoming,
            ),
            borderRadius: BorderRadius.circular(24.r),
            child: Ink(
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.midnightBlue.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      color: AppColors.paleBlueLight,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: const Icon(
                      Iconsax.calendar_1,
                      color: AppColors.blue600,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      'No upcoming appointments yet. Tap to view your bookings.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.grey500,
                  ),
                ],
              ),
            ),
          );
        }

        final appointmentDate = BackendDateTime.parseUtc(
          booking.appointmentDate,
        );
        final formattedDate = Formatter.formatTimeForDoctor(appointmentDate);
        final formattedTime = Formatter.formatDateForDoctor(appointmentDate);
        final surfaceColor = Theme.of(context).cardColor;

        return InkWell(
          onTap: () => context.pushNamed(
            AppRoutes.myBookings,
            extra: BookingStatus.upcoming,
          ),
          borderRadius: BorderRadius.circular(24.r),
          child: Ink(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.midnightBlue.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 74.w,
                  height: 74.w,
                  decoration: BoxDecoration(
                    color: AppColors.cardImageBackground,
                    borderRadius: BorderRadius.circular(18.r),
                    image: booking.doctorAvatar != null
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(
                              booking.doctorAvatar!,
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: booking.doctorAvatar == null
                      ? Icon(
                          Iconsax.user,
                          color: AppColors.grey400,
                          size: 30.sp,
                        )
                      : null,
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
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Text(
                              DoctorAppointmentStatus.label(
                                booking.status ??
                                    DoctorAppointmentStatus.upcoming,
                              ),
                              style: TextStyle(
                                color: AppColors.actionGreen,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        booking.department,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(
                            Iconsax.calendar_1,
                            color: AppColors.grey500,
                            size: 16.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            formattedDate,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          SizedBox(width: 12.w),
                          Icon(
                            Iconsax.clock,
                            color: AppColors.grey500,
                            size: 16.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            formattedTime,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                      if (summary.totalUpcomingCount > 1) ...[
                        SizedBox(height: 10.h),
                        Text(
                          '${summary.totalUpcomingCount} upcoming appointments',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.grey500,
                  size: 24.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
