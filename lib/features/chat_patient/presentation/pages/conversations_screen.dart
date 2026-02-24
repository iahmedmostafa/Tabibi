import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/DI/service_locator.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/usecases/chat_usecases.dart';
import '../widgets/conversation_list_tile.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
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
          'Chats',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<List<ConversationEntity>>(
        future: _conversationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.midnightBlue),
            );
          }

          if (snapshot.hasError) return _buildErrorView(snapshot.error);

          final conversations = snapshot.data ?? [];
          if (conversations.isEmpty) return _buildEmptyView();

          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            color: AppColors.midnightBlue,
            child: _buildConversationList(conversations),
          );
        },
      ),
    );
  }

  Widget _buildConversationList(List<ConversationEntity> conversations) {
    return ListView.separated(
      itemCount: conversations.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, indent: 80.w, color: AppColors.grey200),
      itemBuilder: (context, index) => ConversationListTile(
        conversation: conversations[index],
        onNavigateBack: _refresh,
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80.sp,
            color: AppColors.grey300,
          ),
          SizedBox(height: 16.h),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.grey600,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your conversations will appear here',
            style: TextStyle(fontSize: 14.sp, color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(Object? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            'Failed to load chats',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.grey700,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.midnightBlue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
