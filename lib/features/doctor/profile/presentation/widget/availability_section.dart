import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/profile/domain/entities/doctor_profile_entity.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/section_card.dart';
import 'package:tabibi/features/doctor/profile/presentation/widget/settings_item.dart';

class AvailabilitySection extends StatelessWidget {
  final DoctorProfileEntity profile;

  const AvailabilitySection({super.key, required this.profile});

  String _getWorkingHoursSummary() {
    if (profile.schedule.isEmpty) return '';
    final first = profile.schedule.first;
    return '${first.openTime} - ${first.closeTime}';
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Availability',
      child: SettingsItem(
        icon: Icons.schedule_rounded,
        iconColor: AppTheme.blueIcon,
        iconBgColor: AppTheme.bluePastel,
        title: 'Working Hours',
        subtitle: _getWorkingHoursSummary(),
        onTap: () {},
      ),
    );
  }
}
