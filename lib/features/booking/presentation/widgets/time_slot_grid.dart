import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/booking/presentation/controller/appointment_cubit.dart';

class TimeSlotGrid extends StatelessWidget {
  final Function(String) onTimeSelected;

  const TimeSlotGrid({super.key, required this.onTimeSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        final cubit = context.read<AppointmentCubit>();

        if (state is AppointmentSlotsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AppointmentSlotsFailure) {
          return Center(child: Text(state.message));
        }

        if (cubit.availableSlots.isEmpty) {
          return const Center(child: Text("No slots available for this date"));
        }

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
          ),
          itemCount: cubit.availableSlots.length,
          itemBuilder: (context, index) {
            final slot = cubit.availableSlots[index];
            final isSelected = cubit.selectedTime == slot.startTime;
            final isAvailable = slot.isAvailable;

            return GestureDetector(
              onTap: isAvailable
                  ? () {
                      cubit.selectTime(slot.startTime);
                      onTimeSelected(slot.startTime);
                    }
                  : null,
              child: Opacity(
                opacity: isAvailable ? 1.0 : 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.grey300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      formatIsoTo12Hour(slot.startTime),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.dark,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
String formatIsoTo12Hour(String isoDate) {
  final dateTime = DateTime.parse(isoDate).toLocal(); 
  return DateFormat('hh:mm a').format(dateTime);
}