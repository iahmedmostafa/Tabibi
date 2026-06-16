import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/divider.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/section_card.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/settings_item.dart';

class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Security',
      child: Column(
        children: [
          SettingsItem(
            icon: Icons.lock_outline_rounded,
            iconColor: AppTheme.purpleIcon,
            iconBgColor: AppTheme.purplePastel,
            title: 'Change Password',
            onTap: () {},
          ),
          const DividerWidget(),
          SettingsItem(
            icon: Icons.notifications_outlined,
            iconColor: AppTheme.orangeIcon,
            iconBgColor: AppTheme.orangePastel,
            title: 'Notifications',
            subtitle: 'Enabled',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
