import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/extensions/date_time_extension.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/features/notifications/domain/entities/notification_entity.dart';
import 'package:tabibi/features/notifications/presentation/cubit/notifications_cubit.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    return InkWell(
      onTap: () {
        if (!notification.isRead) {
          context.read<NotificationsCubit>().markAsRead(notification.id);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.h16),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: !notification.isRead
              ? isDark
                    ? AppColors.primary
                    : AppColors.white
              : isDark
              ? AppColors.dark
              : AppColors.grey50,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(notification.type),
            SizedBox(width: AppWidth.w16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTime(notification.createdAt),
                        style: TextStyle(
                          color: AppColors.grey500,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppHeight.h4),
                  Text(
                    notification.message
                        .formatNotificationMessageTime()
                        .toLocalTimeStrings(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime createdAt) {
    // Convert current time to the same timezone basis as createdAt to get accurate difference.
    // Assuming createdAt has already been parsed and mapped to `toLocal()` in the Model.
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  Widget _buildIcon(NotificationType type) {
    Color color;
    IconData icon;
    Color iconColor;

    switch (type) {
      case NotificationType.bookingAlert:
        color = const Color(0xFFDEF7E4);
        icon = Iconsax.calendar;
        iconColor = AppColors.success;
      case NotificationType.system:
        color = const Color(0xFFF3F4F6);
        icon = Iconsax.notification;
        iconColor = AppColors.grey500;
      case NotificationType.chatMessage:
        color = const Color(0xFFE8F0FE);
        icon = Iconsax.message;
        iconColor = AppColors.midnightBlue;
      case NotificationType.payment:
        color = const Color(0xFFFFF3E0);
        icon = Iconsax.money;
        iconColor = const Color(0xFFFF9800);
    }

    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 24.sp),
    );
  }
}
