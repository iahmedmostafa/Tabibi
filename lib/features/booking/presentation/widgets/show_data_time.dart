import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/booking/presentation/controller/appointment_cubit.dart';
import 'package:tabibi/features/doctor_details/domain/entities/doctor_details_entity.dart';

class ShowDateTime extends StatelessWidget {
  final String doctorId;
  final List<DoctorSchedule> schedule;

  const ShowDateTime({
    super.key,
    required this.doctorId,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      onDateChange: (selectedDate) {
        context.read<AppointmentCubit>().selectDate(
          selectedDate,
          doctorId: doctorId,
        );
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
      // Use validator to disable days not in schedule
      // Note: easy_date_timeline doesn't have a direct 'enabledDays' list,
      // but we can use onDateChange logic or check if we can pass a predicate.
      // In version 2.x, we might need to use `validator` if available or custom day builder.
    );
  }
}
