import '../../domain/entities/chat_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.message,
    required super.sentAt,
    required super.isMe,
    required super.isRead,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      sentAt: (() {
        String s = json['sentAt'] ?? '';
        if (s.isNotEmpty && !s.endsWith('Z')) s += 'Z';
        return DateTime.tryParse(s)?.toLocal() ?? DateTime.now();
      })(),
      isMe: json['isMe'] ?? false,
      isRead: json['isRead'] ?? false,
    );
  }
}

class ChatResponseModel extends ChatResponseEntity {
  const ChatResponseModel({required super.canChat, required super.messages});

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      canChat: json['canChat'] ?? false,
      messages: json['messages'] != null
          ? List<MessageModel>.from(
              (json['messages'] as List).map((x) => MessageModel.fromJson(x)),
            )
          : [],
    );
  }
}

class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.otherUserId,
    required super.otherUserName,
    super.otherUserImage,
    required super.lastMessage,
    required super.lastMessageTime,
    required super.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      otherUserId: json['otherUserId'] ?? '',
      otherUserName: json['otherUserName'] ?? '',
      otherUserImage: json['otherUserImage'],
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: (() {
        String s = json['lastMessageTime'] ?? '';
        if (s.isNotEmpty && !s.endsWith('Z')) s += 'Z';
        return DateTime.tryParse(s)?.toLocal() ?? DateTime.now();
      })(),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}
