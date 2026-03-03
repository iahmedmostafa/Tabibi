import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/patients/domain/entities/patient.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/allergies_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/contact_information_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/documents_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/medical_history_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/patient_header_card.dart';
import 'package:tabibi/features/doctor/patients/presentation/widgets/previous_visits_card.dart';

class PatientProfilePage extends StatelessWidget {
  final Patient patient;

  const PatientProfilePage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Patient Profile', style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Edit',
              style: TextStyle(color: AppTheme.primaryColor, fontSize: 16.sp),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PatientHeaderCard(patient: patient),
            SizedBox(height: 16.h),
            ContactInformationCard(patient: patient),
            SizedBox(height: 16.h),
            MedicalHistoryCard(patient: patient),
            SizedBox(height: 16.h),
            AllergiesCard(patient: patient),
            SizedBox(height: 16.h),
            PreviousVisitsCard(patient: patient),
            SizedBox(height: 16.h),
            const DocumentsCard(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
