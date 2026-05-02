import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/divider.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/settings_item.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Account',
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
                icon: Icons.person_outline,
                title: 'Personal Information',
                subtitle: 'Edit profile',
                onTap: () {},
              ),
              const DividerWidget(),
              SettingsItem(
                icon: Icons.business_outlined,
                title: 'Clinic Information',
                subtitle: 'Medical Center',
                onTap: () {},
              ),
              const DividerWidget(),
              SettingsItem(
                icon: Icons.star_outline,
                title: 'Specialization',
                subtitle: 'Cardiology',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
