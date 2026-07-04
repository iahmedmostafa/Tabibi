import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/notifications/domain/entities/notification_entity.dart';
import 'package:tabibi/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:tabibi/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:tabibi/features/notifications/presentation/widgets/notification_item.dart';
import 'package:tabibi/features/notifications/presentation/widgets/notification_section_header.dart';
import 'package:tabibi/features/notifications/presentation/widgets/unread_notification_bloc_builder.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          icon: const Icon(Iconsax.arrow_left_2, color: AppColors.grey500),
          onPressed: () {
            context.pop();
          },
        ),
        actions: const [UnReadNotificationBlocBuilder()],
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          switch (state.status) {
            case NotificationsStatus.initial:
            case NotificationsStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case NotificationsStatus.error:
              return Center(child: Text(state.errorMessage));
            case NotificationsStatus.loaded:
              if (state.notifications.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      SvgPicture.asset(AppImages.empty),
                      Text('noNotificationsYet'.tr()),
                    ],
                  ),
                );
              }
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final yesterday = today.subtract(const Duration(days: 1));
              final todayNotifications = state.notifications
                  .where(
                    (n) =>
                        n.createdAt.isAfter(today) ||
                        n.createdAt.isAtSameMomentAs(today),
                  )
                  .toList();
              final yesterdayNotifications = state.notifications
                  .where(
                    (n) =>
                        n.createdAt.isAfter(yesterday) &&
                        n.createdAt.isBefore(today),
                  )
                  .toList();
              final olderNotifications = state.notifications
                  .where((n) => n.createdAt.isBefore(yesterday))
                  .toList();

              return SingleChildScrollView(
                padding: EdgeInsets.all(AppWidth.w20),
                child: Column(
                  children: [
                    if (todayNotifications.isNotEmpty) ...[
                      NotificationSectionHeader(
                        title: AppStrings.today,
                        onMarkAllAsRead: () =>
                            context.read<NotificationsCubit>().markAllAsRead(),
                      ),
                      SizedBox(height: AppHeight.h16),
                      ..._buildNotificationList(todayNotifications),
                      SizedBox(height: AppHeight.h24),
                    ],
                    if (yesterdayNotifications.isNotEmpty) ...[
                      NotificationSectionHeader(title: AppStrings.yesterday),
                      SizedBox(height: AppHeight.h16),
                      ..._buildNotificationList(yesterdayNotifications),
                      SizedBox(height: AppHeight.h24),
                    ],
                    if (olderNotifications.isNotEmpty) ...[
                      NotificationSectionHeader(title: 'older'.tr()),
                      SizedBox(height: AppHeight.h16),
                      ..._buildNotificationList(olderNotifications),
                    ],
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  List<Widget> _buildNotificationList(List<NotificationEntity> notifications) {
    return notifications.map((n) => NotificationItem(notification: n)).toList();
  }
}
