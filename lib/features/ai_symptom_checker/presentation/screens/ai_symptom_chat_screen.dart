import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/ai_symptom_checker/presentation/cubit/ai_symptom_cubit.dart';
import 'package:tabibi/features/ai_symptom_checker/presentation/cubit/ai_symptom_state.dart';

class AiSymptomChatScreen extends StatefulWidget {
  const AiSymptomChatScreen({super.key});

  @override
  State<AiSymptomChatScreen> createState() => _AiSymptomChatScreenState();
}

class ChatMessage {
  final String text;
  final bool isUser;
  final Widget? customContent;
  ChatMessage({required this.text, required this.isUser, this.customContent});
}

class _AiSymptomChatScreenState extends State<AiSymptomChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(text: 'aiHealthAssistantIntro'.tr(), isUser: false),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _messageController.clear();
    });

    _scrollToBottom();
    context.read<AiSymptomCubit>().checkSymptoms(text);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('aiHealthAssistant'.tr()),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<AiSymptomCubit, AiSymptomState>(
              listener: (context, state) {
                if (state is AiSymptomSuccess) {
                  setState(() {
                    _messages.add(
                      ChatMessage(text: state.result.answer, isUser: false),
                    );
                  });
                  _scrollToBottom();
                } else if (state is AiSymptomFailure) {
                  setState(() {
                    _messages.add(
                      ChatMessage(
                        text: 'sorryError'.tr(
                          namedArgs: {'message': state.message},
                        ),
                        isUser: false,
                      ),
                    );
                  });
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16.r),
                  itemCount:
                      _messages.length + (state is AiSymptomLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length) {
                      return _buildLoadingBubble();
                    }
                    final message = _messages[index];
                    return _buildMessageBubble(message);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: message.isUser
              ? AppColors.blue
              : (isDark ? AppColors.grey800 : AppColors.grey100),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(message.isUser ? 16.r : 0),
            bottomRight: Radius.circular(message.isUser ? 0 : 16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.text.isNotEmpty)
              Text(
                message.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: message.isUser
                      ? Colors.white
                      : (isDark ? Colors.white : Colors.black87),
                ),
              ),
            if (message.customContent != null) ...[
              if (message.text.isNotEmpty) SizedBox(height: 12.h),
              message.customContent!,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBubble() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.grey800 : AppColors.grey100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: const Radius.circular(0),
            bottomRight: Radius.circular(16.r),
          ),
        ),
        child: const SizedBox(width: 48, height: 24, child: TypingIndicator()),
      ),
    );
  }

  Widget _buildMessageInput() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'typeYourSymptoms'.tr(),
                hintStyle: const TextStyle(color: AppColors.grey400),
                filled: true,
                fillColor: isDark ? AppColors.grey800 : AppColors.grey50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 14.h,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Iconsax.send_1, color: Colors.white, size: 24.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _animation1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );
    _animation2 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );
    _animation3 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -5 * (0.5 - (0.5 - animation.value).abs()) * 2),
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.grey400,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDot(_animation1),
        _buildDot(_animation2),
        _buildDot(_animation3),
      ],
    );
  }
}
