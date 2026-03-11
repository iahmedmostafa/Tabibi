import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/video_call/domain/entities/video_call_entity.dart';
import 'package:tabibi/features/video_call/domain/repositories/video_call_repository.dart';

class GetVideoTokenUseCase {
  final VideoCallRepository repository;

  GetVideoTokenUseCase(this.repository);

  Future<Either<Failure, VideoCallEntity>> execute(String bookingId) async {
    return await repository.getVideoToken(bookingId);
  }
}
