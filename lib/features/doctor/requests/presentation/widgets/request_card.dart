import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/formatters.dart/formatters.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_card.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_status_badge.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';
import 'package:tabibi/features/doctor/requests/domain/entities/appointment_request.dart';
import 'package:easy_localization/easy_localization.dart';

class RequestCard extends StatelessWidget {
  final AppointmentRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const RequestCard({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusData = _statusData(request.status);

    return DoctorCard(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.grey800 : AppColors.grey100,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.person,
                  color: isDark ? AppColors.grey400 : AppColors.grey500,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.patientName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14.sp,
                          color: isDark ? AppColors.grey400 : AppColors.grey500,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${Formatter.formatDateForDoctor(request.dateTime)} - ${Formatter.formatTimeForDoctor(request.dateTime)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.grey400
                                : AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.videocam,
                  color: AppColors.primary,
                  size: 28.sp,
                ),
                onPressed: () {
                  context.push(
                    AppRoutes.callPage,
                    extra: {'bookingId': request.id},
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            request.reason,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.grey400 : AppColors.grey500,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16.h),
          if (request.isUpcoming)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46.h,
                    child: OutlinedButton.icon(
                      onPressed: onReject,
                      icon: Icon(Icons.close, size: 18.sp),
                      label: Text(
                        'reject'.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.lightPink),
                        backgroundColor: AppColors.lightPink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: SizedBox(
                    height: 46.h,
                    child: ElevatedButton.icon(
                      onPressed: onApprove,
                      icon: Icon(Icons.check, size: 18.sp),
                      label: Text(
                        'approve'.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            DoctorStatusBadge(
              label: _statusLabel(),
              color: statusData.color,
              backgroundColor: statusData.bgColor,
            ),
        ],
      ),
    );
  }

  String _statusLabel() {
    return request.statusLabel;
  }

  _StatusColors _statusData(int status) {
    switch (status) {
      case DoctorAppointmentStatus.upcoming:
        return _StatusColors(AppColors.blue, AppColors.paleBlueLight);
      case DoctorAppointmentStatus.completed:
        return _StatusColors(AppColors.actionGreen, AppColors.successLight);
      case DoctorAppointmentStatus.refunded:
        return _StatusColors(AppColors.error, AppColors.lightPink);
      default:
        return _StatusColors(AppColors.grey400, AppColors.grey100);
    }
  }
}

class _StatusColors {
  final Color color;
  final Color bgColor;
  const _StatusColors(this.color, this.bgColor);
}
