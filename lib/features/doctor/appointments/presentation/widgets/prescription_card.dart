import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Prescription / Diagnosis', style: tt.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
          SizedBox(height: 16.h),
          _buildRow(context, 'Diagnosis', prescription.diagnosis),
          Divider(height: 24.h, color: Theme.of(context).dividerColor),
          _buildRow(
            context,
            'Notes',
            prescription.notes?.isNotEmpty == true ? prescription.notes! : 'None',
          ),
          if (prescription.medicines.isNotEmpty) ...[
            Divider(height: 24.h, color: Theme.of(context).dividerColor),
            Text(
              'Medicines (${prescription.medicines.length})',
              style: tt.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            ...prescription.medicines.map((medicine) => _buildMedicineItem(context, medicine)),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicineItem(BuildContext context, dynamic med) {
    final tt = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medication_outlined, size: 18.sp, color: Theme.of(context).colorScheme.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  med.medicineName,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(child: _buildDetailCol(context, 'Dosage', med.dosage)),
              Expanded(child: _buildDetailCol(context, 'Frequency', med.frequency)),
              Expanded(child: _buildDetailCol(context, 'Duration', med.duration)),
            ],
          ),
          if (med.instructions.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _buildDetailCol(context, 'Instructions', med.instructions),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailCol(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    final tt = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label, style: tt.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: tt.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
