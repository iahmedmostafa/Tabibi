import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_card.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_section_header.dart';
import 'package:tabibi/features/doctor_profile/domain/entities/doctor_profile.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/divider.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/settings_item.dart';

class AccountSection extends StatelessWidget {
  final DoctorProfile profile;
  final VoidCallback? onPersonalInfoTap;
  final VoidCallback? onClinicInfoTap;

  const AccountSection({
    super.key,
    required this.profile,
    this.onPersonalInfoTap,
    this.onClinicInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = DoctorLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: DoctorSectionHeader(title: loc.account),
        ),
        SizedBox(height: 12.h),
        DoctorCard(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SettingsItem(
                icon: Icons.person_outline,
                title: loc.personalInfo,
                subtitle: loc.editProfile,
                onTap: onPersonalInfoTap ?? () {},
              ),
              DividerWidget(isDark: isDark),
              SettingsItem(
                icon: Icons.business_outlined,
                title: loc.clinicInfo,
                subtitle: profile.clinic.name.isNotEmpty ? profile.clinic.name : loc.clinicInfo,
                onTap: onClinicInfoTap ?? () {},
              ),
              DividerWidget(isDark: isDark),
              SettingsItem(
                icon: Icons.star_outline,
                title: loc.specialization,
                subtitle: profile.departmentName.isNotEmpty ? profile.departmentName : loc.doctor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
