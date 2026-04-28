import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/settings_item.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          color: Colors.white,
          child: SettingsItem(
            icon: Icons.star_border,
            iconColor: const Color(0xFFFFB74D),
            title: 'View My Reviews',
            onTap: () => context.push(AppRoutes.doctorReviewsPage),
          ),
        ),
      ],
    );
  }
}
