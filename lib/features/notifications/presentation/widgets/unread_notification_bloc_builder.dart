import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:tabibi/features/notifications/presentation/cubit/notifications_state.dart';

class UnReadNotificationBlocBuilder extends StatelessWidget {
  const UnReadNotificationBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        if (state.unreadCount > 0) {
          return Container(
            margin: EdgeInsets.only(right: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.midnightBlue,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              "${state.unreadCount} ${AppStrings.newTag}",
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
