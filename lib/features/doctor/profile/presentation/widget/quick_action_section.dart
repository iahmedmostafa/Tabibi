import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/settings_item.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            AppStrings.doctorQuickActions,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          color: theme.colorScheme.surface,
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
