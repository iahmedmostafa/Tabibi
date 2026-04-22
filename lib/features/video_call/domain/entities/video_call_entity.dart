import 'package:equatable/equatable.dart';

class VideoCallEntity extends Equatable {
  final String token;
  final String roomId;
  final String userId;
  final String userName;
  final int appId;

  const VideoCallEntity({
    required this.token,
    required this.roomId,
    required this.userId,
    required this.userName,
    required this.appId,
  });

  @override
  List<Object?> get props => [token, roomId, userId, userName, appId];
}
