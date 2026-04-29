import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/booking/data/models/create_review_params.dart';

abstract class ReviewRepository {
  Future<Either<Failure, void>> createReview(CreateReviewParams params);
}
