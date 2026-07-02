import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/chat/presentation/widgets/chat_localizations.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.07),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(top: BorderSide(color: isDark ? AppColors.grey800 : Colors.transparent)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTextField(context, isDark)),
          SizedBox(width: 10.w),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, bool isDark) {
    final loc = ChatLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey800 : const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: isDark ? AppColors.grey700 : Colors.transparent),
      ),
      child: TextField(
        controller: controller,
        maxLines: 4,
        minLines: 1,
        textInputAction: TextInputAction.send,
        onSubmitted: (_) => onSend(),
        style: TextStyle(
          fontSize: 14.5.sp,
          color: isDark ? AppColors.white : AppColors.grey800,
        ),
        decoration: InputDecoration(
          hintText: loc.typeMessage,
          hintStyle: TextStyle(
            color: isDark ? AppColors.grey500 : AppColors.grey400,
            fontSize: 14.sp,
          ),
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

class ChatExpiredBar extends StatelessWidget {
  const ChatExpiredBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = ChatLocalizations.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      color: isDark ? AppColors.darkSurface : Colors.white,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.grey800 : const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isDark ? AppColors.grey700 : const Color(0xFFFFE082),
          ),
        ),
        child: Text(
          '⏳  ${loc.expiredBar}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? AppColors.grey200 : const Color(0xFF92400E),
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }
}
