import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_action_buttons.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_info_card.dart';
import 'package:tabibi/features/doctor/appointments/presentation/widgets/appointment_patient_info_card.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/appointment.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Appointment Details', style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.description_outlined,
              size: 24.sp,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            AppointmentPatientInfoCard(appointment: appointment),
            SizedBox(height: 16.h),
            AppointmentInfoCard(appointment: appointment),
            SizedBox(height: 16.h),
            _ReasonForVisitCard(appointment: appointment),
            SizedBox(height: 16.h),
            _MedicalHistoryCard(appointment: appointment),
            SizedBox(height: 24.h),
            const AppointmentActionButtons(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

class _ReasonForVisitCard extends StatelessWidget {
  final Appointment appointment;

  const _ReasonForVisitCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reason for Visit',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12.h),
          Text(
            appointment.type,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicalHistoryCard extends StatelessWidget {
  final Appointment appointment;

  const _MedicalHistoryCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medical History',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          _buildHistoryRow('Last Visit', appointment.lastVisit),
          Divider(height: 24.h, color: Colors.grey[200]),
          _buildHistoryRow('Allergies', appointment.allergies),
          Divider(height: 24.h, color: Colors.grey[200]),
          _buildHistoryRow('Current Medications', appointment.medications),
        ],
      ),
    );
  }

  Widget _buildHistoryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
