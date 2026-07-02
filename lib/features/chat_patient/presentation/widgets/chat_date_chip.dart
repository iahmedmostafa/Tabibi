import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/chat/presentation/widgets/chat_localizations.dart';

class ChatDateChip extends StatelessWidget {
  final DateTime date;

  const ChatDateChip({required this.date, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = ChatLocalizations.of(context);
    final dividerColor = isDark ? AppColors.grey800 : AppColors.grey300;
    final chipBg = isDark ? AppColors.grey800 : AppColors.grey200;
    final textColor = isDark ? AppColors.grey200 : AppColors.grey600;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Expanded(child: Divider(color: dividerColor, thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: chipBg,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                _getLabel(loc),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(child: Divider(color: dividerColor, thickness: 1)),
        ],
      ),
    );
  }

  String _getLabel(ChatLocalizations loc) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final locale = loc.isAr ? 'ar' : 'en';

    if (_isSameDay(date, now)) return loc.isAr ? 'اليوم' : 'Today';
    if (_isSameDay(date, yesterday)) return loc.yesterday;
    return DateFormat('MMMM d, yyyy', locale).format(date);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
