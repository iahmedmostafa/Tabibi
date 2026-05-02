import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/divider.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/settings_item.dart';

class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Security',
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
          child: Column(
            children: [
              SettingsItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                onTap: () {},
              ),
              const DividerWidget(),
              SettingsItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Enabled',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
