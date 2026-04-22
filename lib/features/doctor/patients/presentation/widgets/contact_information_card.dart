import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/features/doctor/patients/domain/entities/patient.dart';

class ContactInformationCard extends StatelessWidget {
  final Patient patient;

  const ContactInformationCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          _buildContactRow(Icons.phone, const Color(0xFF2196F3), patient.phone),
          SizedBox(height: 16.h),
          _buildContactRow(Icons.email, const Color(0xFF4CAF50), patient.email),
          SizedBox(height: 16.h),
          _buildContactRow(
            Icons.location_on,
            const Color(0xFFFF9800),
            patient.address,
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, Color iconColor, String text) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: iconColor, size: 20.sp),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[800]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
