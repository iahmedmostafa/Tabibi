import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ScheduleEmptyState extends StatelessWidget {
  const ScheduleEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64.sp, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text(
            'noAppointmentsForDay'.tr(),
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
