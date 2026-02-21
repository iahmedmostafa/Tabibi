import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String message;
  final DateTime sentAt;
  final bool isMe;
  final bool isRead;

  const MessageEntity({
    required this.id,
    required this.message,
    required this.sentAt,
    required this.isMe,
    required this.isRead,
  });

  @override
  List<Object?> get props => [id, message, sentAt, isMe, isRead];
}

class ChatResponseEntity extends Equatable {
  final bool canChat;
  final List<MessageEntity> messages;

  const ChatResponseEntity({required this.canChat, required this.messages});

  ChatResponseEntity copyWith({bool? canChat, List<MessageEntity>? messages}) {
    return ChatResponseEntity(
      canChat: canChat ?? this.canChat,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [canChat, messages];
}

class ConversationEntity extends Equatable {
  final String otherUserId;
  final String otherUserName;
  final String? otherUserImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  const ConversationEntity({
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserImage,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [
    otherUserId,
    otherUserName,
    otherUserImage,
    lastMessage,
    lastMessageTime,
    unreadCount,
  ];
}
