import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/profile/domain/entities/doctor_profile_entity.dart';

class ClinicInfoSection extends StatelessWidget {
  final ClinicEntity clinic;

  const ClinicInfoSection({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clinic Information',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
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
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: AppTheme.bluePastel,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.local_hospital, color: AppTheme.primaryColor),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clinic.name,
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                          if (clinic.description != null && clinic.description!.isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            Text(
                              clinic.description!,
                              style: TextStyle(fontSize: 13.sp, color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Divider(color: theme.dividerColor.withOpacity(0.5)),
                SizedBox(height: 16.h),
                _buildInfoRow(context, Icons.location_on_outlined, clinic.address),
                if (clinic.city != null) ...[
                  SizedBox(height: 12.h),
                  _buildInfoRow(context, Icons.location_city_outlined, clinic.city!.name),
                ],
                SizedBox(height: 12.h),
                _buildInfoRow(context, Icons.phone_outlined, clinic.phoneNumber),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: Theme.of(context).colorScheme.onSurfaceVariant),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
