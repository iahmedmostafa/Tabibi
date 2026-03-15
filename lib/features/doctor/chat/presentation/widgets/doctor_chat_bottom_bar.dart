import 'package:flutter/material.dart';
import 'package:tabibi/features/chat_patient/domain/entities/chat_entity.dart';
import 'package:tabibi/features/chat_patient/presentation/widgets/chat_input_bar.dart';

class DoctorChatBottomBar extends StatelessWidget {
  final Stream<ChatResponseEntity> chatStream;
  final TextEditingController controller;
  final bool hasText;
  final VoidCallback onSend;

  const DoctorChatBottomBar({
    super.key,
    required this.chatStream,
    required this.controller,
    required this.hasText,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChatResponseEntity>(
      stream: chatStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.data!.canChat) {
          return const ChatExpiredBar();
        }
        return ChatInputBar(
          controller: controller,
          hasText: hasText,
          onSend: onSend,
        );
      },
    );
  }
}
