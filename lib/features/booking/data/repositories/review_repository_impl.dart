import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/booking/data/datasources/review_remote_data_source.dart';
import 'package:tabibi/features/booking/data/models/create_review_params.dart';
import 'package:tabibi/features/booking/domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> createReview(CreateReviewParams params) async {
    try {
      await remoteDataSource.createReview(params);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
