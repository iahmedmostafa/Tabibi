import 'package:dio/dio.dart';
import '../../../../core/network/api_constance.dart';
import '../models/chat_model.dart';
import '../../../../core/network/server_connection.dart';

abstract class ChatRemoteDataSource {
  Future<List<ConversationModel>> getConversations();
  Future<ChatResponseModel> getChatMessages(String otherUserId);
  Future<void> sendChatMessage(String receiverId, String content);
  Stream<dynamic> get onChatMessageReceived;
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ConversationModel>> getConversations() async {
    try {
      final response = await dio.get(ApiConstance.conversations);
      return (response.data as List)
          .map((json) => ConversationModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Server error');
    }
  }

  @override
  Future<ChatResponseModel> getChatMessages(String otherUserId) async {
    try {
      final response = await dio.get(ApiConstance.chatMessages(otherUserId));
      return ChatResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Server error');
    }
  }

  @override
  Future<void> sendChatMessage(String receiverId, String content) async {
    try {
      await dio.post(
        ApiConstance.sendChatMessage,
        data: {"receiverId": receiverId, "content": content},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Server error');
    }
  }

  @override
  Stream<dynamic> get onChatMessageReceived =>
      ServerConnection().onChatMessageReceived;
}
