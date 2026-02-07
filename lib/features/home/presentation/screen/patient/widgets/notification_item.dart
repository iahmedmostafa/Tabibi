import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/features/home/domain/entities/notification_entity.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppHeight.h16),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: notification.isNew ? Colors.white : Colors.transparent,
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
                    Text(
                      notification.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      notification.time,
                      style: TextStyle(
                        color: AppColors.grey500,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppHeight.h4),
                Text(
                  notification.description,
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
    );
  }

  Widget _buildIcon(NotificationType type) {
    Color color;
    IconData icon;
    Color iconColor;

    switch (type) {
      case NotificationType.success:
        color = const Color(0xFFDEF7E4);
        icon = Icons.calendar_today;
        iconColor = AppColors.success;
        break;
      case NotificationType.cancelled:
        color = const Color(0xFFFDE8E8);
        icon = Icons.calendar_today;
        iconColor = AppColors.error;
        break;
      case NotificationType.changed:
        color = const Color(0xFFF3F4F6);
        icon = Icons.edit_calendar;
        iconColor = AppColors.midnightBlue;
        break;
    }

    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 24.sp),
    );
  }
}
