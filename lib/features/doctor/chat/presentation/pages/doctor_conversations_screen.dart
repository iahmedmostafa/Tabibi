import 'package:flutter/material.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/chat_patient/domain/entities/chat_entity.dart';
import 'package:tabibi/features/chat_patient/domain/usecases/chat_usecases.dart';
import 'package:tabibi/features/doctor/chat/presentation/widgets/doctor_conversations_list.dart';
import 'package:tabibi/features/doctor/chat/presentation/widgets/doctor_conversations_states.dart';

class DoctorConversationsScreen extends StatefulWidget {
  const DoctorConversationsScreen({super.key});

  @override
  State<DoctorConversationsScreen> createState() =>
      _DoctorConversationsScreenState();
}

class _DoctorConversationsScreenState
    extends State<DoctorConversationsScreen> {
  final _getConversationsUseCase = sl<GetConversationsUseCase>();
  late Future<List<ConversationEntity>> _conversationsFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _conversationsFuture = _getConversationsUseCase.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patient Chats',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<ConversationEntity>>(
        future: _conversationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.midnightBlue),
            );
          }
          if (snapshot.hasError) {
            return DoctorConversationsErrorState(onRetry: _refresh);
          }

          final conversations = snapshot.data ?? [];
          if (conversations.isEmpty) {
            return const DoctorConversationsEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            color: AppColors.midnightBlue,
            child: DoctorConversationsList(
              conversations: conversations,
              onNavigateBack: _refresh,
            ),
          );
        },
      ),
    );
  }
}
