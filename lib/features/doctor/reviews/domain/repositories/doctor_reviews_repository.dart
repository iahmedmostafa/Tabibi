import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/reviews/domain/entities/review.dart';

class DoctorReviewsResult {
  final RatingSummary summary;
  final List<Review> reviews;

  const DoctorReviewsResult({
    required this.summary,
    required this.reviews,
  });
}

abstract class DoctorReviewsRepository {
  Future<Either<Failure, DoctorReviewsResult>> getMyReviews({
    required int page,
    required int pageSize,
    int? rating,
  });
}
