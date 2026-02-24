import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/constants/app_colors.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool hasText;
  final VoidCallback onSend;

  const ChatInputBar({
    required this.controller,
    required this.hasText,
    required this.onSend,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildTextField()),
          SizedBox(width: 10.w),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: TextField(
        controller: controller,
        maxLines: 4,
        minLines: 1,
        textInputAction: TextInputAction.send,
        onSubmitted: (_) => onSend(),
        style: TextStyle(fontSize: 14.5.sp, color: AppColors.grey800),
        decoration: InputDecoration(
          hintText: 'Type a message…',
          hintStyle: TextStyle(color: AppColors.grey400, fontSize: 14.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 18.w,
            vertical: 11.h,
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return AnimatedScale(
      scale: hasText ? 1.0 : 0.85,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTap: onSend,
        child: Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: hasText
                  ? [AppColors.midnightBlue, const Color(0xFF2D4A6A)]
                  : [AppColors.grey300, AppColors.grey400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.send_rounded, color: Colors.white, size: 20.sp),
        ),
      ),
    );
  }
}

/// Shown when canChat == false after data is loaded
class ChatExpiredBar extends StatelessWidget {
  const ChatExpiredBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Text(
        '🔒  This chat has expired.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.grey500, fontSize: 13.sp),
      ),
    );
  }
}
