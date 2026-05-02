import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/profile/domain/entities/doctor_profile_entity.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/divider.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/section_card.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/settings_item.dart';

class AccountSection extends StatelessWidget {
  final DoctorProfileEntity profile;

  const AccountSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Account',
      child: Column(
        children: [
          SettingsItem(
            icon: Icons.person_outline_rounded,
            iconColor: AppTheme.blueIcon,
            iconBgColor: AppTheme.bluePastel,
            title: 'Personal Information',
            subtitle: 'Edit profile',
            onTap: () {
              context.push(AppRoutes.doctorEditProfile, extra: profile).then((updated) {
                if (updated == true) {
                  // optionally reload the profile data in DoctorProfileCubit
                }
              });
            },
          ),
          const DividerWidget(),
          SettingsItem(
            icon: Icons.local_hospital_outlined,
            iconColor: AppTheme.greenIcon,
            iconBgColor: AppTheme.greenPastel,
            title: 'Clinic Information',
            subtitle: profile.clinic?.name,
            onTap: () {},
          ),
          const DividerWidget(),
          SettingsItem(
            icon: Icons.workspace_premium_outlined,
            iconColor: AppTheme.orangeIcon,
            iconBgColor: AppTheme.orangePastel,
            title: 'Specialization',
            subtitle: profile.department?.name,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
