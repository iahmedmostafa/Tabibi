import '../entities/chat_entity.dart';

abstract class ChatRepository {
  Future<List<ConversationEntity>> getConversations();
  Stream<ChatResponseEntity> getChatMessagesStream(String otherUserId);
  Future<void> sendChatMessage(String receiverId, String content);
  void dispose();
}
