import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/section_card.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/settings_item.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: AppStrings.doctorQuickActions,
      child: SettingsItem(
        icon: Icons.star_rounded,
        iconColor: AppTheme.orangeIcon,
        iconBgColor: AppTheme.orangePastel,
        title: 'View My Reviews',
        onTap: () => context.push(AppRoutes.doctorReviewsPage),
      ),
    );
  }
}
