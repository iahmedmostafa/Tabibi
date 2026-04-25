import 'dart:async';
import 'dart:convert';
import 'dart:developer';
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
      log("ChatRepo received from SignalR: $data");
      Map<String, dynamic>? decodedData;
      try {
        if (data is Map) {
          decodedData = Map<String, dynamic>.from(data);
        } else if (data is String) {
          decodedData = jsonDecode(data);
        }
      } catch (e) {
        log("Error decoding SignalR data: $e");
      }

      // Decode data into MessageEntity (SendChatMessageDto format: Id, SenderId, Message, SentAt)
      if (decodedData != null) {
        // handle Signalr capitalized keys or camelCase keys
        final senderId = decodedData['SenderId']?.toString() ?? decodedData['senderId']?.toString();
        log("Parsed SenderId: $senderId, Expected otherUserId: $otherUserId");
        
        // We add the message if it belongs to this conversation (either from the other person or ourself if not duplicated)
        // Wait, if it's from us, it was already added optimistically. 
        if (senderId != null && senderId.toLowerCase() == otherUserId.toLowerCase()) {
          final newMessage = MessageEntity(
            id: decodedData['Id']?.toString() ?? decodedData['id']?.toString() ?? DateTime.now().toString(),
            message: decodedData['Message'] ?? decodedData['message'] ?? '',
            sentAt:
                DateTime.tryParse(decodedData['SentAt'] ?? decodedData['sentAt'] ?? '') ??
                DateTime.now(),
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
