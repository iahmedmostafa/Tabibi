import 'package:tabibi/features/video_call/domain/entities/video_call_entity.dart';

class VideoCallModel extends VideoCallEntity {
  const VideoCallModel({
    required super.token,
    required super.roomId,
    required super.userId,
    required super.userName,
    required super.appId,
  });

  factory VideoCallModel.fromJson(Map<String, dynamic> json) {
    // Attempt to safely parse appId as int, handling cases where it is sent as a String
    int parsedAppId = 0;
    if (json['appId'] != null) {
      if (json['appId'] is int) {
        parsedAppId = json['appId'];
      } else if (json['appId'] is String) {
        parsedAppId = int.tryParse(json['appId']) ?? 0;
      }
    }

    return VideoCallModel(
      token: json['token'] ?? '',
      roomId: json['roomId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      appId: parsedAppId,
    );
  }
}
