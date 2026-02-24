import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../domain/entities/chat_entity.dart';

class ChatMessageBubble extends StatelessWidget {
  final MessageEntity message;

  const ChatMessageBubble({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Padding(
      padding: EdgeInsets.only(
        bottom: 4.h,
        left: isMe ? 60.w : 0,
        right: isMe ? 0 : 60.w,
      ),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            _buildBubble(isMe),
            SizedBox(height: 3.h),
            _buildTimestamp(isMe),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(bool isMe) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isMe ? AppColors.midnightBlue : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.r),
          topRight: Radius.circular(18.r),
          bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
          bottomRight: Radius.circular(isMe ? 4.r : 18.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        message.message,
        style: TextStyle(
          color: isMe ? Colors.white : AppColors.grey800,
          fontSize: 14.5.sp,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildTimestamp(bool isMe) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat('HH:mm').format(message.sentAt),
          style: TextStyle(fontSize: 10.sp, color: AppColors.grey500),
        ),
        if (isMe) ...[
          SizedBox(width: 4.w),
          Icon(
            message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
            size: 14.sp,
            color: message.isRead ? AppColors.teal : AppColors.grey400,
          ),
        ],
      ],
    );
  }
}
