import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/formatters.dart/formatters.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/doctor_appointment_status.dart';
import 'package:tabibi/features/doctor/requests/domain/entities/appointment_request.dart';

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
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${Formatter.formatDateForDoctor(request.dateTime)} - ${Formatter.formatTimeForDoctor(request.dateTime)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
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
                  color: AppTheme.primaryColor,
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
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16.h),
          if (request.isUpcoming)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    icon: Icon(Icons.close, size: 18.sp),
                    label: Text('Reject', style: TextStyle(fontSize: 14.sp)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.redIcon,
                      side: const BorderSide(color: AppTheme.redPastel),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onApprove,
                    icon: Icon(Icons.check, size: 18.sp),
                    label: Text('Approve', style: TextStyle(fontSize: 14.sp)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _statusBackgroundColor(),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                _statusLabel(),
                style: TextStyle(
                  color: _statusTextColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _statusLabel() {
    return request.statusLabel;
  }

  Color _statusBackgroundColor() {
    switch (request.status) {
      case DoctorAppointmentStatus.refunded:
        return AppTheme.redPastel;
      case DoctorAppointmentStatus.completed:
        return AppTheme.greenPastel;
      case DoctorAppointmentStatus.upcoming:
        return AppTheme.bluePastel;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _statusTextColor() {
    switch (request.status) {
      case DoctorAppointmentStatus.refunded:
        return AppTheme.redIcon;
      case DoctorAppointmentStatus.completed:
        return AppTheme.greenIcon;
      case DoctorAppointmentStatus.upcoming:
        return AppTheme.blueIcon;
      default:
        return Colors.grey.shade700;
    }
  }
}
