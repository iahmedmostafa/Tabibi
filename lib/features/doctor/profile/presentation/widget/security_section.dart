import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_card.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_section_header.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/divider.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/settings_item.dart';

class SecuritySection extends StatelessWidget {
  final VoidCallback? onChangePasswordTap;
  final VoidCallback? onNotificationsTap;

  const SecuritySection({
    super.key,
    this.onChangePasswordTap,
    this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = DoctorLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: DoctorSectionHeader(title: loc.security),
        ),
        SizedBox(height: 12.h),
        DoctorCard(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SettingsItem(
                icon: Icons.lock_outline,
                title: loc.changePassword,
                onTap: onChangePasswordTap,
              ),
              DividerWidget(),
              SettingsItem(
                icon: Icons.notifications_outlined,
                title: loc.notifications,
                subtitle: loc.enabled,
                onTap: onNotificationsTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
