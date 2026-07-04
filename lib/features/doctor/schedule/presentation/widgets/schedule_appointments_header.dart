import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';

class ScheduleAppointmentsHeader extends StatelessWidget {
  final int count;
  final DateTime selectedDate;

  const ScheduleAppointmentsHeader({
    super.key,
    required this.count,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count ${"appointmentsLabel".tr()}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 16.sp),
              ),
              Text(
                DateFormat('EEEE, MMM d').format(selectedDate),
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ],
          ),
          TextButton(
            onPressed: () => context.push(AppRoutes.doctorAvailability),
            child: Text(
              'editAvailability'.tr(),
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
