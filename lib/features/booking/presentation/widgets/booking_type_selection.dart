import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/booking/presentation/controller/appointment_cubit.dart';

class BookingTypeSelection extends StatelessWidget {
  const BookingTypeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        final cubit = context.read<AppointmentCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Appointment Type",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _TypeItem(
              title: "Personal",
              icon: Icons.groups_outlined,
              iconColor: Colors.blue,
              value: 0,
              groupValue: cubit.selectedType,
              onChanged: (val) => cubit.selectType(val!),
            ),
            const Divider(),
            _TypeItem(
              title: "Video Call",
              icon: Icons.videocam_outlined,
              iconColor: Colors.green,
              value: 1,
              groupValue: cubit.selectedType,
              onChanged: (val) => cubit.selectType(val!),
            ),
          ],
        );
      },
    );
  }
}

class _TypeItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final int value;
  final int groupValue;
  final ValueChanged<int?> onChanged;

  const _TypeItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Radio<int>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 16.w),
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
          ],
        ),
      ),
    );
  }
}
