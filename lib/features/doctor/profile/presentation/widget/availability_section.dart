import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_card.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_section_header.dart';
import 'package:tabibi/features/doctor_profile/domain/entities/doctor_profile.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/settings_item.dart';

class AvailabilitySection extends StatelessWidget {
  final DoctorProfile profile;
  final VoidCallback? onTap;

  const AvailabilitySection({super.key, required this.profile, this.onTap});

  @override
  Widget build(BuildContext context) {
    final loc = DoctorLocalizations.of(context);

    final workingHoursText = profile.schedule.isNotEmpty
        ? '${profile.schedule.first.openTime} - ${profile.schedule.first.closeTime}'
        : 'notSpecified'.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: DoctorSectionHeader(title: loc.availability),
        ),
        SizedBox(height: 12.h),
        DoctorCard(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.zero,
          child: SettingsItem(
            icon: Icons.access_time,
            title: loc.workingHours,
            subtitle: workingHoursText,
            onTap: onTap ?? () {},
          ),
        ),
      ],
    );
  }
}
