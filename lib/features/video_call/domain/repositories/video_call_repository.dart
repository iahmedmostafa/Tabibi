import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/video_call/domain/entities/video_call_entity.dart';

abstract class VideoCallRepository {
  Future<Either<Failure, VideoCallEntity>> getVideoToken(String bookingId);
}
