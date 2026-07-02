import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_card.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_section_header.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/settings_item.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = DoctorLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: DoctorSectionHeader(title: loc.quickActions),
        ),
        SizedBox(height: 12.h),
        DoctorCard(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.zero,
          child: SettingsItem(
            icon: Icons.star_border,
            iconColor: const Color(0xFFFFB74D),
            title: loc.viewMyReviews,
            onTap: () => context.push(AppRoutes.doctorReviewsPage),
          ),
        ),
      ],
    );
  }
}
