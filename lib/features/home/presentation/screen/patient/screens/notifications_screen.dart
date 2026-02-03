import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/home/presentation/cubit/notifications_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/notification_item.dart';
import 'package:tabibi/features/home/presentation/screen/patient/widgets/notification_section_header.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotificationsCubit>()..getNotifications(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            AppStrings.notification,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.midnightBlue),
            onPressed: () => context.pop(),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.midnightBlue,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                "1 ${AppStrings.newTag}",
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
            ),
          ],
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationsError) {
              return Center(child: Text(state.message));
            } else if (state is NotificationsLoaded) {
              final todayNotifications = state.notifications
                  .where((n) => n.isToday)
                  .toList();
              final yesterdayNotifications = state.notifications
                  .where((n) => !n.isToday)
                  .toList();

              return SingleChildScrollView(
                padding: EdgeInsets.all(AppWidth.w20),
                child: Column(
                  children: [
                    if (todayNotifications.isNotEmpty) ...[
                      const NotificationSectionHeader(title: AppStrings.today),
                      SizedBox(height: AppHeight.h16),
                      ...todayNotifications.map(
                        (n) => NotificationItem(notification: n),
                      ),
                      SizedBox(height: AppHeight.h24),
                    ],
                    if (yesterdayNotifications.isNotEmpty) ...[
                      const NotificationSectionHeader(
                        title: AppStrings.yesterday,
                      ),
                      SizedBox(height: AppHeight.h16),
                      ...yesterdayNotifications.map(
                        (n) => NotificationItem(notification: n),
                      ),
                    ],
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
