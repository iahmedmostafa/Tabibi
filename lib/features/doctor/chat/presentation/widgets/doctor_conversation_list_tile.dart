import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/chat_patient/domain/entities/chat_entity.dart';

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
    final hasImage = conversation.otherUserImage != null &&
        conversation.otherUserImage!.isNotEmpty;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      onTap: () {
        context
            .pushNamed(
              AppRoutes.doctorChat,
              extra: {
                'patientId': conversation.otherUserId,
                'patientName': conversation.otherUserName,
                'patientImage': conversation.otherUserImage,
              },
            )
            .then((_) => onNavigateBack());
      },
      leading: CircleAvatar(
        radius: 28.r,
        backgroundColor: AppColors.grey200,
        backgroundImage: hasImage
            ? CachedNetworkImageProvider(conversation.otherUserImage!)
            : null,
        child: !hasImage
            ? Icon(Icons.person, size: 30.sp, color: AppColors.grey400)
            : null,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              conversation.otherUserName.isNotEmpty
                  ? conversation.otherUserName
                  : 'Unknown Patient',
              style: TextStyle(
                fontWeight: conversation.unreadCount > 0
                    ? FontWeight.bold
                    : FontWeight.w600,
                fontSize: 16.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _formatTime(conversation.lastMessageTime),
            style: TextStyle(
              fontSize: 12.sp,
              color: conversation.unreadCount > 0
                  ? AppColors.midnightBlue
                  : AppColors.grey500,
              fontWeight: conversation.unreadCount > 0
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 6.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                conversation.lastMessage,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: conversation.unreadCount > 0
                      ? Colors.black87
                      : AppColors.grey600,
                  fontWeight: conversation.unreadCount > 0
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (conversation.unreadCount > 0) _buildUnreadBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildUnreadBadge() {
    return Container(
      margin: EdgeInsets.only(left: 8.w),
      padding: EdgeInsets.all(6.w),
      decoration: const BoxDecoration(
        color: AppColors.midnightBlue,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          conversation.unreadCount.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inDays == 0 && now.day == time.day) {
      return DateFormat('HH:mm').format(time);
    } else if (diff.inDays == 1 || (diff.inDays == 0 && now.day != time.day)) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return DateFormat('EEEE').format(time);
    }
    return DateFormat('dd/MM/yyyy').format(time);
  }
}
