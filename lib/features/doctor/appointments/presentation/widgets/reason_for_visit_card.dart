import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';

class ReasonForVisitCard extends StatelessWidget {
  final AppointmentDetailsEntity details;

  const ReasonForVisitCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final typeLabel = details.type == 1 ? 'Video Call' : 'Consultation';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reason for Visit',
            style: tt.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            typeLabel,
            style: tt.bodyMedium?.copyWith(
              height: 1.5,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
