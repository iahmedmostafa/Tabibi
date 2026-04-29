import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/booking/data/models/create_review_params.dart';
import 'package:tabibi/features/booking/domain/repositories/review_repository.dart';

class CreateReviewUseCase {
  final ReviewRepository repository;

  CreateReviewUseCase(this.repository);

  Future<Either<Failure, void>> execute(CreateReviewParams params) {
    return repository.createReview(params);
  }
}
