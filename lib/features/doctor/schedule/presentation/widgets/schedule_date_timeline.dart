import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
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
    return EasyDateTimeLine(
      initialDate: selectedDate,
      onDateChange: (date) {
        onDateChange(date);
        context.read<ScheduleCubit>().getDoctorSchedule(date.toIso8601String());
      },
      headerProps: const EasyHeaderProps(
        monthPickerType: MonthPickerType.switcher,
        dateFormatter: DateFormatter.fullDateDMY(),
      ),
      dayProps: const EasyDayProps(
        dayStructure: DayStructure.dayStrDayNum,
        activeDayStyle: DayStyle(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.blue600, AppColors.primary],
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
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: AppColors.grey100,
          ),
        ),
      ),
    );
  }
}
