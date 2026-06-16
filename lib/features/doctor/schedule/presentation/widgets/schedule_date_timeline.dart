import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/schedule/presentation/cubit/schedule_cubit.dart';

class ScheduleDateTimeline extends StatelessWidget {
  final DateTime selectedDate;
  final void Function(DateTime) onDateChange;

  const ScheduleDateTimeline({
    super.key,
    required this.selectedDate,
    required this.onDateChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return EasyDateTimeLine(
      initialDate: selectedDate,
      onDateChange: (date) {
        onDateChange(date);
        context.read<ScheduleCubit>().getDoctorSchedule(date.toIso8601String());
      },
      headerProps: EasyHeaderProps(
        monthPickerType: MonthPickerType.switcher,
        dateFormatter: const DateFormatter.fullDateDMY(),
        selectedDateStyle: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        monthStyle: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      dayProps: EasyDayProps(
        dayStructure: DayStructure.dayStrDayNum,
        activeDayStyle: const DayStyle(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.blueIcon, AppTheme.primaryColor],
            ),
          ),
          dayNumStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          dayStrStyle: TextStyle(color: Colors.white, fontSize: 12),
        ),
        inactiveDayStyle: DayStyle(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          dayNumStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          dayStrStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        todayStyle: DayStyle(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: AppTheme.primaryColor),
          ),
          dayNumStyle: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          dayStrStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
