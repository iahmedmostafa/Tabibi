import 'package:flutter/material.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/features/chat_patient/domain/entities/chat_entity.dart';
import 'package:tabibi/features/chat_patient/domain/usecases/chat_usecases.dart';
import 'package:tabibi/features/doctor/chat/presentation/widgets/doctor_chat_app_bar.dart';
import 'package:tabibi/features/doctor/chat/presentation/widgets/doctor_chat_body.dart';
import 'package:tabibi/features/doctor/chat/presentation/widgets/doctor_chat_bottom_bar.dart';

class DoctorChatScreen extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String? patientImage;

  const DoctorChatScreen({
    required this.patientId,
    required this.patientName,
    this.patientImage,
    super.key,
  });

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  late final Stream<ChatResponseEntity> _chatStream;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasText = false;

  final _getChatMessagesUseCase = sl<GetChatMessagesUseCase>();
  final _sendChatMessageUseCase = sl<SendChatMessageUseCase>();

  @override
  void initState() {
    super.initState();
    _chatStream = _getChatMessagesUseCase.call(widget.patientId);
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
    _sendChatMessageUseCase.call(receiverId: widget.patientId, content: content);
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
      appBar: DoctorChatAppBar(
        patientName: widget.patientName,
        patientImage: widget.patientImage,
      ),
      body: Column(
        children: [
          Expanded(
            child: DoctorChatBody(
              chatStream: _chatStream,
              scrollController: _scrollController,
              onScrollToBottom: _scrollToBottom,
            ),
          ),
          DoctorChatBottomBar(
            chatStream: _chatStream,
            controller: _messageController,
            hasText: _hasText,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

