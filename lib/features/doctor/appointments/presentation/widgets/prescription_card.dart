import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/appointments/domain/entities/appointment_details_entity.dart';
import 'package:intl/intl.dart';

class PrescriptionCard extends StatelessWidget {
  final PrescriptionEntity prescription;

  const PrescriptionCard({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppTheme.bluePastel,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Row(
              children: [
                Icon(Icons.description_outlined, color: AppTheme.blueIcon, size: 24.sp),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prescription',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.blueIcon,
                        ),
                      ),
                      Text(
                        'Issued on ${DateFormat('MMM dd, yyyy').format(prescription.createdAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.blueIcon.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Diagnosis Section
                _buildSectionHeader(context, Icons.medical_services_outlined, 'Diagnosis'),
                SizedBox(height: 8.h),
                Text(
                  prescription.diagnosis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                
                if (prescription.notes != null && prescription.notes!.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  _buildSectionHeader(context, Icons.note_alt_outlined, 'Notes'),
                  SizedBox(height: 8.h),
                  Text(
                    prescription.notes!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
                
                if (prescription.medicines.isNotEmpty) ...[
                  SizedBox(height: 24.h),
                  Divider(color: theme.dividerColor.withOpacity(0.5), height: 1),
                  SizedBox(height: 20.h),
                  
                  Row(
                    children: [
                      Icon(Icons.medication, color: AppTheme.primaryColor, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Prescribed Medicines (${prescription.medicines.length})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  
                  // Medicines List
                  ...prescription.medicines.map((medicine) => _buildMedicineCard(context, medicine)),
                ] else ...[
                  SizedBox(height: 24.h),
                  Divider(color: theme.dividerColor.withOpacity(0.5), height: 1),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Icon(Icons.medication_outlined, color: theme.colorScheme.onSurfaceVariant, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'No medicines prescribed',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Theme.of(context).colorScheme.onSurfaceVariant),
        SizedBox(width: 6.w),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineCard(BuildContext context, MedicineEntity med) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppTheme.tealDark.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.vaccines, size: 18.sp, color: AppTheme.tealDark),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      med.medicineName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        _buildMedicineBadge(context, med.dosage, AppTheme.orangePastel, AppTheme.orangeIcon),
                        SizedBox(width: 8.w),
                        _buildMedicineBadge(context, med.duration, AppTheme.purplePastel, AppTheme.purpleIcon),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.schedule, size: 14.sp, color: theme.colorScheme.onSurfaceVariant),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    med.frequency,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (med.instructions.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 14.sp, color: theme.colorScheme.primary),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    med.instructions,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicineBadge(BuildContext context, String text, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
