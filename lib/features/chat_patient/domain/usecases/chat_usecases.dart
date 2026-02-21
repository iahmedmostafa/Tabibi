import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class GetConversationsUseCase {
  final ChatRepository repository;

  GetConversationsUseCase(this.repository);

  Future<List<ConversationEntity>> call() {
    return repository.getConversations();
  }
}

class GetChatMessagesUseCase {
  final ChatRepository repository;

  GetChatMessagesUseCase(this.repository);

  Stream<ChatResponseEntity> call(String otherUserId) {
    return repository.getChatMessagesStream(otherUserId);
  }
}

class SendChatMessageUseCase {
  final ChatRepository repository;

  SendChatMessageUseCase(this.repository);

  Future<void> call({required String receiverId, required String content}) {
    return repository.sendChatMessage(receiverId, content);
  }
}
