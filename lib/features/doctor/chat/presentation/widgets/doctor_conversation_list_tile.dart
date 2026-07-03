import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_styles.dart';
import 'package:tabibi/features/chat_patient/domain/entities/chat_entity.dart';
import 'chat_localizations.dart';

class DoctorConversationListTile extends StatelessWidget {
  final ConversationEntity conversation;
  final VoidCallback onNavigateBack;

  const DoctorConversationListTile({
    required this.conversation,
    required this.onNavigateBack,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = ChatLocalizations.of(context);
    final hasImage = conversation.otherUserImage != null &&
        conversation.otherUserImage!.isNotEmpty;

    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRoutes.doctorChat,
          extra: {
            'patientId': conversation.otherUserId,
            'patientName': conversation.otherUserName,
            'patientImage': conversation.otherUserImage,
          },
        ).then((_) => onNavigateBack());
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isDark ? AppColors.grey800.withValues(alpha: 0.5) : AppColors.grey200.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            _buildAvatar(hasImage),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(loc, isDark),
                  SizedBox(height: 5.h),
                  _buildMessagePreview(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(bool hasImage) {
    return CircleAvatar(
      radius: 28.r,
      backgroundColor: AppColors.grey200,
      backgroundImage: hasImage
          ? CachedNetworkImageProvider(conversation.otherUserImage!)
          : null,
      child: !hasImage
          ? Icon(Icons.person_rounded, size: 28.sp, color: AppColors.grey400)
          : null,
    );
  }

  Widget _buildHeader(ChatLocalizations loc, bool isDark) {
    final hasUnread = conversation.unreadCount > 0;
    return Row(
      children: [
        Expanded(
          child: Text(
            conversation.otherUserName.isNotEmpty
                ? conversation.otherUserName
                : loc.unknownPatient,
            style: AppTextStyle.bodySMedium.copyWith(
              fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
              color: isDark ? Colors.white : AppColors.grey800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          _formatTime(conversation.lastMessageTime, loc),
          style: AppTextStyle.bodyXsMedium.copyWith(
            color: hasUnread
                ? AppColors.midnightBlue
                : (isDark ? AppColors.grey400 : AppColors.grey500),
            fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildMessagePreview(bool isDark) {
    final hasUnread = conversation.unreadCount > 0;
    return Row(
      children: [
        Expanded(
          child: Text(
            conversation.lastMessage,
            style: AppTextStyle.bodySRegular.copyWith(
              fontSize: 13.sp,
              color: hasUnread
                  ? (isDark ? Colors.white : AppColors.grey800)
                  : (isDark ? AppColors.grey400 : AppColors.grey600),
              fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (hasUnread) ...[
          SizedBox(width: 8.w),
          _buildUnreadBadge(),
        ],
      ],
    );
  }

  Widget _buildUnreadBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.midnightBlue,
        borderRadius: BorderRadius.circular(10.r),
      ),
      constraints: BoxConstraints(
        minWidth: 20.w,
      ),
      child: Center(
        child: Text(
          conversation.unreadCount.toString(),
          style: AppTextStyle.bodyXsBold.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time, ChatLocalizations loc) {
    final now = DateTime.now();
    final diff = now.difference(time);
    final locale = loc.isAr ? 'ar' : 'en';

    if (diff.inDays == 0 && now.day == time.day) {
      return DateFormat('HH:mm', locale).format(time);
    } else if (diff.inDays == 1 || (diff.inDays == 0 && now.day != time.day)) {
      return loc.yesterday;
    } else if (diff.inDays < 7) {
      return DateFormat('EEEE', locale).format(time);
    }
    return DateFormat('dd/MM/yyyy', locale).format(time);
  }
}
