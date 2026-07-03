import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_card.dart';

class ReasonForVisitCard extends StatelessWidget {
  final AppointmentDetailsEntity details;

  const ReasonForVisitCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeLabel = details.type == 1 ? 'Video Call' : 'Consultation';

    return DoctorCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reason for Visit', style: theme.textTheme.titleLarge),
          SizedBox(height: 12.h),
          Text(
            typeLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
