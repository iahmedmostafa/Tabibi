import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/reviews/data/datasources/doctor_reviews_remote_data_source.dart';
import 'package:tabibi/features/doctor/reviews/domain/repositories/doctor_reviews_repository.dart';

class DoctorReviewsRepositoryImpl implements DoctorReviewsRepository {
  final DoctorReviewsRemoteDataSource remoteDataSource;

  DoctorReviewsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DoctorReviewsResult>> getMyReviews({
    required int page,
    required int pageSize,
    int? rating,
  }) async {
    try {
      final result = await remoteDataSource.getMyReviews(
        page: page,
        pageSize: pageSize,
        rating: rating,
      );
      return Right(
        DoctorReviewsResult(summary: result.summary, reviews: result.reviews),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
