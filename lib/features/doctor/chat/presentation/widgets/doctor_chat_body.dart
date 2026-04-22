import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/chat_patient/domain/entities/chat_entity.dart';
import 'package:tabibi/features/chat_patient/presentation/widgets/chat_date_chip.dart';
import 'package:tabibi/features/chat_patient/presentation/widgets/chat_message_bubble.dart';
import 'package:tabibi/features/chat_patient/presentation/widgets/chat_states.dart';

class DoctorChatBody extends StatelessWidget {
  final Stream<ChatResponseEntity> chatStream;
  final ScrollController scrollController;
  final VoidCallback onScrollToBottom;

  const DoctorChatBody({
    super.key,
    required this.chatStream,
    required this.scrollController,
    required this.onScrollToBottom,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChatResponseEntity>(
      stream: chatStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.midnightBlue,
              strokeWidth: 2.5,
            ),
          );
        }
        if (snapshot.hasError) return const ChatErrorState();
        if (!snapshot.hasData) return const ChatEmptyState();

        final response = snapshot.data!;
        WidgetsBinding.instance
            .addPostFrameCallback((_) => onScrollToBottom());

        return Column(
          children: [
            if (!response.canChat) const ChatExpiredBanner(),
            Expanded(
              child: response.messages.isEmpty
                  ? const ChatEmptyState()
                  : _MessagesList(
                      messages: response.messages,
                      scrollController: scrollController,
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _MessagesList extends StatelessWidget {
  final List<MessageEntity> messages;
  final ScrollController scrollController;

  const _MessagesList({
    required this.messages,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final prev = index > 0 ? messages[index - 1] : null;
        final showDate =
            prev == null || !_isSameDay(msg.sentAt, prev.sentAt);
        return Column(
          children: [
            if (showDate) ChatDateChip(date: msg.sentAt),
            ChatMessageBubble(message: msg),
          ],
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
