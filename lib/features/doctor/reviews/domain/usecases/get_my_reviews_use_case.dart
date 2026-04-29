import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/reviews/domain/repositories/doctor_reviews_repository.dart';

class GetMyReviewsUseCase {
  final DoctorReviewsRepository repository;

  GetMyReviewsUseCase(this.repository);

  Future<Either<Failure, DoctorReviewsResult>> execute({
    int page = 1,
    int pageSize = 100,
    int? rating,
  }) {
    return repository.getMyReviews(
      page: page,
      pageSize: pageSize,
      rating: rating,
    );
  }
}
