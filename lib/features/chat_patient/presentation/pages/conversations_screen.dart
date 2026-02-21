import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/DI/service_locator.dart';
import '../../../../core/routing/app_routes.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/usecases/chat_usecases.dart';

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
    _loadConversations();
  }

  void _loadConversations() {
    _conversationsFuture = _getConversationsUseCase.call();
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
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text('Failed to load chats: ${snapshot.error}'),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loadConversations();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final conversations = snapshot.data ?? [];

          if (conversations.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _loadConversations();
              });
            },
            child: ListView.separated(
              itemCount: conversations.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, indent: 80.w, color: Colors.grey[200]),
              itemBuilder: (context, index) {
                final chat = conversations[index];
                return _buildConversationItem(chat);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80.sp, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your conversations will appear here',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationItem(ConversationEntity chat) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      onTap: () {
        context.pushNamed(AppRoutes.chat, extra: chat.otherUserId).then((_) {
          // Refresh when coming back in case of new messages
          setState(() {
            _loadConversations();
          });
        });
      },
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                chat.otherUserImage != null && chat.otherUserImage!.isNotEmpty
                ? NetworkImage(chat.otherUserImage!)
                : null,
            child: chat.otherUserImage == null || chat.otherUserImage!.isEmpty
                ? Icon(Icons.person, size: 30.sp, color: Colors.grey[400])
                : null,
          ),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              chat.otherUserName.isNotEmpty
                  ? chat.otherUserName
                  : 'Unknown Doctor',
              style: TextStyle(
                fontWeight: chat.unreadCount > 0
                    ? FontWeight.bold
                    : FontWeight.w600,
                fontSize: 16.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _formatChatTime(chat.lastMessageTime),
            style: TextStyle(
              fontSize: 12.sp,
              color: chat.unreadCount > 0
                  ? Theme.of(context).primaryColor
                  : Colors.grey[500],
              fontWeight: chat.unreadCount > 0
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 6.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                chat.lastMessage,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: chat.unreadCount > 0
                      ? Colors.black87
                      : Colors.grey[600],
                  fontWeight: chat.unreadCount > 0
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (chat.unreadCount > 0)
              Container(
                margin: EdgeInsets.only(left: 8.w),
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    chat.unreadCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatChatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0 && now.day == time.day) {
      // Today
      return DateFormat('HH:mm').format(time);
    } else if (difference.inDays == 1 ||
        (difference.inDays == 0 && now.day != time.day)) {
      // Yesterday
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      // Within last week
      return DateFormat('EEEE').format(time);
    } else {
      // Older
      return DateFormat('dd/MM/yyyy').format(time);
    }
  }
}
