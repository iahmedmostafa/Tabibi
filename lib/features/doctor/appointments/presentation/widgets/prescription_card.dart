import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';

class PrescriptionCard extends StatelessWidget {
  final PrescriptionEntity prescription;

  const PrescriptionCard({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Prescription / Diagnosis', style: tt.titleLarge?.copyWith(color: AppColors.grey800)),
          SizedBox(height: 16.h),
          _buildRow(context, 'Diagnosis', prescription.diagnosis),
          Divider(height: 24.h, color: Colors.grey[200]),
          _buildRow(
            context,
            'Notes',
            prescription.notes?.isNotEmpty == true ? prescription.notes! : 'None',
          ),
          if (prescription.medicines.isNotEmpty) ...[
            Divider(height: 24.h, color: Colors.grey[200]),
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
    final tt = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label, style: tt.labelSmall?.copyWith(color: AppColors.grey500))),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: tt.bodyMedium?.copyWith(color: AppColors.grey800),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
