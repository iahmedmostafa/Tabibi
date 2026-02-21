import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/DI/service_locator.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/usecases/chat_usecases.dart';

class ChatScreen extends StatefulWidget {
  final String doctorId;
  const ChatScreen({required this.doctorId, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Stream<ChatResponseEntity> _chatStream;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final getChatMessagesUseCase = sl<GetChatMessagesUseCase>();
  final sendChatMessageUseCase = sl<SendChatMessageUseCase>();

  @override
  void initState() {
    super.initState();
    _chatStream = getChatMessagesUseCase.call(widget.doctorId);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final content = _messageController.text.trim();
    _messageController.clear();

    sendChatMessageUseCase.call(receiverId: widget.doctorId, content: content);

    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<ChatResponseEntity>(
              stream: _chatStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('No messages yet'));
                }

                final chatResponse = snapshot.data!;
                final messages = chatResponse.messages;

                return Column(
                  children: [
                    if (!chatResponse.canChat)
                      Container(
                        padding: EdgeInsets.all(12.h),
                        color: Colors.amber.withOpacity(0.2),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.amber),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'The chat is currently unavailable. Chat is available only for 7 days after the appointment.',
                                style: TextStyle(
                                  color: Colors.amber[800],
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isMe = msg.isMe;

                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 4.h,
                              ),
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.r),
                                  topRight: Radius.circular(12.r),
                                  bottomLeft: isMe
                                      ? Radius.circular(12.r)
                                      : Radius.circular(0),
                                  bottomRight: isMe
                                      ? Radius.circular(0)
                                      : Radius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                msg.message,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return StreamBuilder<ChatResponseEntity>(
      stream: _chatStream,
      builder: (context, snapshot) {
        final canChat = snapshot.data?.canChat ?? false;

        if (!canChat) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
