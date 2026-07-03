import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tabibi/features/chat_patient/domain/entities/chat_entity.dart';
import 'package:tabibi/features/doctor/chat/presentation/widgets/doctor_conversation_list_tile.dart';

class DoctorConversationsList extends StatelessWidget {
  final List<ConversationEntity> conversations;
  final VoidCallback onNavigateBack;

  const DoctorConversationsList({
    super.key,
    required this.conversations,
    required this.onNavigateBack,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 350),
            child: SlideAnimation(
              verticalOffset: 24.0,
              child: FadeInAnimation(
                child: DoctorConversationListTile(
                  conversation: conversation,
                  onNavigateBack: onNavigateBack,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
