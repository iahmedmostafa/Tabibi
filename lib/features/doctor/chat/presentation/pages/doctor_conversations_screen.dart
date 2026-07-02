import 'package:flutter/material.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/chat_patient/domain/entities/chat_entity.dart';
import 'package:tabibi/features/chat_patient/domain/usecases/chat_usecases.dart';
import 'package:tabibi/features/doctor/chat/presentation/widgets/doctor_conversations_list.dart';
import 'package:tabibi/features/doctor/chat/presentation/widgets/doctor_conversations_states.dart';
import 'package:tabibi/features/doctor/chat/presentation/widgets/doctor_search_bar.dart';
import 'package:tabibi/features/doctor/chat/presentation/widgets/chat_localizations.dart';
import 'package:tabibi/features/doctor/core/widgets/doctor_loading_state.dart';

class DoctorConversationsScreen extends StatefulWidget {
  const DoctorConversationsScreen({super.key});

  @override
  State<DoctorConversationsScreen> createState() =>
      _DoctorConversationsScreenState();
}

class _DoctorConversationsScreenState extends State<DoctorConversationsScreen> {
  final _getConversationsUseCase = sl<GetConversationsUseCase>();
  late Future<List<ConversationEntity>> _conversationsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final loc = ChatLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          loc.patientChats,
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        backgroundColor: isDark ? AppColors.grey900 : AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          DoctorSearchBar(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
          Expanded(
            child: FutureBuilder<List<ConversationEntity>>(
              future: _conversationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const DoctorLoadingState();
                }
                if (snapshot.hasError) {
                  return DoctorConversationsErrorState(onRetry: _refresh);
                }

                final conversations = snapshot.data ?? [];
                if (conversations.isEmpty) {
                  return const DoctorConversationsEmptyState();
                }

                final filtered = conversations.where((conv) {
                  final name = conv.otherUserName.toLowerCase();
                  return name.contains(_searchQuery.trim().toLowerCase());
                }).toList();

                if (filtered.isEmpty && _searchQuery.isNotEmpty) {
                  return const DoctorConversationsEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async => _refresh(),
                  color: AppColors.midnightBlue,
                  child: DoctorConversationsList(
                    conversations: filtered,
                    onNavigateBack: _refresh,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
