import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/core/doctor_localizations.dart';
import 'package:tabibi/features/doctor/availability/presentation/cubit/availability_cubit.dart';
import 'package:tabibi/features/doctor/availability/presentation/cubit/availability_state.dart';
import 'package:tabibi/features/doctor/availability/presentation/widgets/add_slot_dialog.dart';

class EditAvailabilityPage extends StatelessWidget {
  const EditAvailabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = DoctorLocalizations.of(context);

    return BlocListener<AvailabilityCubit, AvailabilityState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == AvailabilityStatus.success ||
              current.status == AvailabilityStatus.error),
      listener: (context, state) {
        if (state.status == AvailabilityStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'availabilitySaved'.tr(),
                style: TextStyle(fontSize: 14.sp),
              ),
              backgroundColor: AppColors.midnightBlue,
            ),
          );
          context.pop();
        } else if (state.status == AvailabilityStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'failedToSaveAvailability'.tr(),
                style: TextStyle(fontSize: 14.sp),
              ),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<AvailabilityCubit>().resetStatus();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            loc.availability,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 24.sp,
              color: isDark ? Colors.white : AppColors.grey900,
            ),
            onPressed: () => context.pop(),
          ),
          actions: [
            BlocBuilder<AvailabilityCubit, AvailabilityState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                final isSaving = state.status == AvailabilityStatus.loading;
                return TextButton(
                  onPressed: isSaving
                      ? null
                      : () => context.read<AvailabilityCubit>().save(),
                  child: isSaving
                      ? SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'saveLabel'.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.midnightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                );
              },
            ),
          ],
          surfaceTintColor: Colors.transparent,
        ),
        body: BlocBuilder<AvailabilityCubit, AvailabilityState>(
          buildWhen: (previous, current) =>
              previous.isInitialLoading != current.isInitialLoading,
          builder: (context, state) {
            if (state.isInitialLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _WorkingDaysSection(),
                  SizedBox(height: 32.h),
                  const _TimeSlotsSection(),
                  SizedBox(height: 32.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WorkingDaysSection extends StatelessWidget {
  const _WorkingDaysSection();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AvailabilityCubit, AvailabilityState>(
      buildWhen: (previous, current) =>
          previous.workingDays != current.workingDays,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'workingDaysLabel'.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.grey900,
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isDark ? AppColors.grey800 : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: state.workingDays.entries.map((entry) {
                  return Column(
                    children: [
                      SwitchListTile(
                        title: Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: isDark ? Colors.white : AppColors.grey900,
                          ),
                        ),
                        value: entry.value,
                        activeColor: AppColors.midnightBlue,
                        activeTrackColor: AppColors.midnightBlue.withValues(
                          alpha: 0.3,
                        ),
                        onChanged: (value) {
                          context.read<AvailabilityCubit>().toggleWorkingDay(
                            entry.key,
                            value,
                          );
                        },
                      ),
                      if (entry.key != 'Sunday')
                        Divider(
                          height: 1.h,
                          color: isDark
                              ? AppColors.grey800
                              : const Color(0xFFE2E8F0),
                          indent: 16.w,
                          endIndent: 16.w,
                        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  'timeSlotsLabel'.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.grey900,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final cubit = context.read<AvailabilityCubit>();
                    showDialog(
                      context: context,
                      builder: (_) => BlocProvider.value(
                        value: cubit,
                        child: const AddSlotDialog(),
                      ),
                    );
                  },
                  icon: Icon(Icons.add, size: 18.sp),
                  label: Text(
                    'addSlot'.tr(),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.midnightBlue,
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
                    'noTimeSlotsYet'.tr(),
                    style: TextStyle(
                      color: isDark ? AppColors.grey400 : AppColors.grey600,
                      fontSize: 14.sp,
                    ),
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
  final dynamic slot;

  const _TimeSlotItem({required this.slot});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.grey800 : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            slot.day,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : AppColors.grey900,
            ),
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
                  style: TextStyle(
                    color: isDark ? AppColors.grey500 : AppColors.grey400,
                    fontSize: 14.sp,
                  ),
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
                  color: AppColors.lightPink.withValues(
                    alpha: isDark ? 0.2 : 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: isDark ? Colors.red.shade400 : AppColors.error,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.grey800 : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              size: 18.sp,
              color: isDark ? AppColors.grey400 : AppColors.grey500,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                time,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: isDark ? Colors.white : AppColors.grey900,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
