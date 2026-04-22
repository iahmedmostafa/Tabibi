import 'package:equatable/equatable.dart';
import 'package:tabibi/features/video_call/domain/entities/video_call_entity.dart';

abstract class VideoCallState extends Equatable {
  const VideoCallState();

  @override
  List<Object?> get props => [];
}

class VideoCallInitial extends VideoCallState {}

class VideoCallLoading extends VideoCallState {}

class VideoCallSuccess extends VideoCallState {
  final VideoCallEntity data;

  const VideoCallSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class VideoCallFailure extends VideoCallState {
  final String message;

  const VideoCallFailure(this.message);

  @override
  List<Object?> get props => [message];
}
