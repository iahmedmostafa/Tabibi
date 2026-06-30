import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/features/chat_patient/presentation/widgets/chat_input_bar.dart';
import '../../../../core/DI/service_locator.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/usecases/chat_usecases.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_date_chip.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_states.dart';

class ChatScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String? doctorImage;

  const ChatScreen({
    required this.doctorId,
    required this.doctorName,
    this.doctorImage,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final Stream<ChatResponseEntity> _chatStream;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasText = false;

  final _getChatMessagesUseCase = sl<GetChatMessagesUseCase>();
  final _sendChatMessageUseCase = sl<SendChatMessageUseCase>();

  @override
  void initState() {
    super.initState();
    _chatStream = _getChatMessagesUseCase.call(widget.doctorId);
    _messageController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _messageController.text.trim().isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    final content = _messageController.text.trim();
    _messageController.clear();
    _sendChatMessageUseCase.call(receiverId: widget.doctorId, content: content);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    Future.delayed(const Duration(milliseconds: 120), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF0F4F8),
      appBar: ChatAppBar(
        doctorName: widget.doctorName,
        doctorImage: widget.doctorImage,
      ),
      body: Column(
        children: [
          Expanded(child: _buildBody()),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<ChatResponseEntity>(
      stream: _chatStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.midnightBlue,
              strokeWidth: 2.5,
            ),
          );
        }

        if (snapshot.hasError) return const ChatErrorState();
        if (!snapshot.hasData) return const ChatEmptyState();

        final response = snapshot.data!;
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

        return Column(
          children: [
            if (!response.canChat) const ChatExpiredBanner(),
            Expanded(
              child: response.messages.isEmpty
                  ? const ChatEmptyState()
                  : _buildMessagesList(response.messages),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessagesList(List<MessageEntity> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final prev = index > 0 ? messages[index - 1] : null;
        final showDate = prev == null || !_isSameDay(msg.sentAt, prev.sentAt);
        return Column(
          children: [
            if (showDate) ChatDateChip(date: msg.sentAt),
            ChatMessageBubble(message: msg),
          ],
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return StreamBuilder<ChatResponseEntity>(
      stream: _chatStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.data!.canChat) {
          return const ChatExpiredBar();
        }
        return ChatInputBar(
          controller: _messageController,
          hasText: _hasText,
          onSend: _sendMessage,
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
