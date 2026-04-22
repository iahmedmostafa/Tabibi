import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
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
    return ListView.separated(
      itemCount: conversations.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, indent: 80.w, color: AppColors.grey200),
      itemBuilder: (context, index) => DoctorConversationListTile(
        conversation: conversations[index],
        onNavigateBack: onNavigateBack,
      ),
    );
  }
}
