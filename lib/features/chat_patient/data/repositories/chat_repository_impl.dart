import 'dart:async';

import '../../domain/entities/chat_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  StreamController<ChatResponseEntity>? _controller;
  StreamSubscription? _signalRSubscription;
  ChatResponseEntity? _currentState;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ConversationEntity>> getConversations() async {
    return await remoteDataSource.getConversations();
  }

  @override
  Stream<ChatResponseEntity> getChatMessagesStream(String otherUserId) {
    if (_controller != null && !_controller!.isClosed) {
      _controller!.close();
    }
    _signalRSubscription?.cancel();

    _controller = StreamController<ChatResponseEntity>.broadcast();

    // 1. Fetch initial HTTP GET
    remoteDataSource
        .getChatMessages(otherUserId)
        .then((response) {
          _currentState = response;
          if (_controller?.isClosed == false) {
            _controller?.add(_currentState!);
          }
        })
        .catchError((error) {
          if (_controller?.isClosed == false) {
            _controller?.addError(error);
          }
        });

    // 2. Listen to SignalR Stream
    _signalRSubscription = remoteDataSource.onChatMessageReceived.listen((
      data,
    ) {
      // Decode data into MessageEntity (SendChatMessageDto format: Id, SenderId, Message, SentAt)
      if (data is Map) {
        // handle Signalr capitalized keys or camelCase keys
        final senderId = data['SenderId'] ?? data['senderId'];
        if (senderId == otherUserId) {
          final newMessage = MessageEntity(
            id: data['Id'] ?? data['id'] ?? '',
            message: data['Message'] ?? data['message'] ?? '',
            sentAt: (() {
              String s = data['SentAt'] ?? data['sentAt'] ?? '';
              if (s.isNotEmpty && !s.endsWith('Z')) s += 'Z';
              return DateTime.tryParse(s)?.toLocal() ?? DateTime.now();
            })(),
            isMe: false,
            isRead: false,
          );
          if (_currentState != null) {
            _currentState = _currentState!.copyWith(
              messages: List.from(_currentState!.messages)..add(newMessage),
            );
            if (_controller?.isClosed == false) {
              _controller?.add(_currentState!);
            }
          }
        }
      }
    });

    return _controller!.stream;
  }

  @override
  Future<void> sendChatMessage(String receiverId, String content) async {
    // 1. Optimistically update the stream UI first for instant feedback.
    if (_currentState != null) {
      final newMessage = MessageEntity(
        id: DateTime.now().toString(), // local temporary ID
        message: content,
        sentAt: DateTime.now(),
        isMe: true,
        isRead: false,
      );
      _currentState = _currentState!.copyWith(
        messages: List.from(_currentState!.messages)..add(newMessage),
      );
      if (_controller?.isClosed == false) {
        _controller?.add(_currentState!);
      }
    }

    // 2. send message using HTTP POST
    await remoteDataSource.sendChatMessage(receiverId, content);
  }

  @override
  void dispose() {
    _signalRSubscription?.cancel();
    _controller?.close();
  }
}
