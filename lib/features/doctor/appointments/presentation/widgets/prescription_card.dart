import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_card.dart';

class PrescriptionCard extends StatelessWidget {
  final PrescriptionEntity prescription;

  const PrescriptionCard({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DoctorCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Prescription / Diagnosis', style: theme.textTheme.titleLarge),
          SizedBox(height: 16.h),
          _buildRow(context, 'Diagnosis', prescription.diagnosis),
          Divider(height: 24.h, color: isDark ? AppColors.grey800 : AppColors.grey200),
          _buildRow(
            context,
            'Notes',
            prescription.notes?.isNotEmpty == true ? prescription.notes! : 'None',
          ),
          if (prescription.medicines.isNotEmpty) ...[
            Divider(height: 24.h, color: isDark ? AppColors.grey800 : AppColors.grey200),
            _buildRow(
              context,
              'Medicines',
              '${prescription.medicines.length} Item(s)',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.grey400 : AppColors.grey500,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
