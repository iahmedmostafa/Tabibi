import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/utils/theme/theme.dart';
import 'package:tabibi/features/doctor/availability/presentation/cubit/availability_cubit.dart';
import 'package:tabibi/features/doctor/availability/presentation/cubit/availability_state.dart';
import 'package:tabibi/features/doctor/availability/presentation/widgets/add_break_dialog.dart';
import 'package:tabibi/features/doctor/availability/presentation/widgets/add_slot_dialog.dart';

class EditAvailabilityPage extends StatelessWidget {
  const EditAvailabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Availability', style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.sp),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Availability saved!',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              );
              context.pop();
            },
            child: Text('Save', style: TextStyle(fontSize: 16.sp)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _WorkingDaysSection(),
            SizedBox(height: 32.h),
            const _TimeSlotsSection(),
            SizedBox(height: 32.h),
            const _BreakTimesSection(),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

class _WorkingDaysSection extends StatelessWidget {
  const _WorkingDaysSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailabilityCubit, AvailabilityState>(
      buildWhen: (previous, current) =>
          previous.workingDays != current.workingDays,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Working Days',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 20.sp),
            ),
            SizedBox(height: 16.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: state.workingDays.entries.map((entry) {
                  return Column(
                    children: [
                      SwitchListTile(
                        title: Text(
                          entry.key,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        value: entry.value,
                        activeTrackColor: AppTheme.primaryColor,
                        onChanged: (value) {
                          context.read<AvailabilityCubit>().toggleWorkingDay(
                            entry.key,
                            value,
                          );
                        },
                      ),
                      if (entry.key != 'Sunday')
                        Divider(height: 1.h, indent: 16.w, endIndent: 16.w),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TimeSlotsSection extends StatelessWidget {
  const _TimeSlotsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailabilityCubit, AvailabilityState>(
      buildWhen: (previous, current) => previous.timeSlots != current.timeSlots,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time Slots',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 20.sp),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AddSlotDialog(),
                    );
                  },
                  icon: Icon(Icons.add, size: 18.sp),
                  label: Text('Add Slot', style: TextStyle(fontSize: 14.sp)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (state.timeSlots.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Text(
                    'No time slots added yet',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
                  ),
                ),
              )
            else
              ...state.timeSlots.map((slot) => _TimeSlotItem(slot: slot)),
          ],
        );
      },
    );
  }
}

class _TimeSlotItem extends StatelessWidget {
  final dynamic
  slot; // Using dynamic to avoid import issues, but should be TimeSlot

  const _TimeSlotItem({required this.slot});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            slot.day,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _TimeChip(
                  time: slot.startTimeString,
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: slot.startTime,
                    );
                    if (time != null && context.mounted) {
                      context.read<AvailabilityCubit>().updateTimeSlot(
                        slot.id,
                        startTime: time,
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  'to',
                  style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                ),
              ),
              Expanded(
                child: _TimeChip(
                  time: slot.endTimeString,
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: slot.endTime,
                    );
                    if (time != null && context.mounted) {
                      context.read<AvailabilityCubit>().updateTimeSlot(
                        slot.id,
                        endTime: time,
                      );
                    }
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.redPastel,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppTheme.redIcon,
                    size: 20.sp,
                  ),
                  onPressed: () =>
                      context.read<AvailabilityCubit>().removeTimeSlot(slot.id),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String time;
  final VoidCallback onTap;

  const _TimeChip({required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, size: 18.sp, color: Colors.grey),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                time,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakTimesSection extends StatelessWidget {
  const _BreakTimesSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailabilityCubit, AvailabilityState>(
      buildWhen: (previous, current) =>
          previous.breakTimes != current.breakTimes,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Break Times',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 20.sp),
                ),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AddBreakDialog(),
                    );
                  },
                  icon: Icon(Icons.add, size: 18.sp),
                  label: Text('Add Break', style: TextStyle(fontSize: 14.sp)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (state.breakTimes.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Text(
                    'No break times added yet',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
                  ),
                ),
              )
            else
              ...state.breakTimes.map((breakTime) {
                return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey, size: 20.sp),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          '${breakTime.startTimeString} - ${breakTime.endTimeString}',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                      Text(
                        '(${breakTime.label})',
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      ),
                      SizedBox(width: 12.w),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: AppTheme.redIcon,
                          size: 20.sp,
                        ),
                        onPressed: () => context
                            .read<AvailabilityCubit>()
                            .removeBreakTime(breakTime.id),
                      ),
                    ],
                  ),
                );
              }),
          ],
        );
      },
    );
  }
}
