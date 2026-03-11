import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/video_call/data/datasources/video_call_remote_data_source.dart';
import 'package:tabibi/features/video_call/domain/entities/video_call_entity.dart';
import 'package:tabibi/features/video_call/domain/repositories/video_call_repository.dart';

class VideoCallRepositoryImpl implements VideoCallRepository {
  final VideoCallRemoteDataSource remoteDataSource;

  VideoCallRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, VideoCallEntity>> getVideoToken(
    String bookingId,
  ) async {
    try {
      final result = await remoteDataSource.getVideoToken(bookingId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.formattedErrors));
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
