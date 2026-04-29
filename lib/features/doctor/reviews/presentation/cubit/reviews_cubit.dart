import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/doctor/reviews/domain/entities/review.dart';
import 'package:tabibi/features/doctor/reviews/domain/usecases/get_my_reviews_use_case.dart';
import 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final GetMyReviewsUseCase getMyReviewsUseCase;

  ReviewsCubit(this.getMyReviewsUseCase)
    : super(
        const ReviewsState(
          summary: RatingSummary(
            averageRating: 0,
            totalReviews: 0,
            ratingDistribution: {5: 0, 4: 0, 3: 0, 2: 0, 1: 0},
          ),
          allReviews: [],
          filteredReviews: [],
        ),
      );

  Future<void> getReviews() async {
    emit(state.copyWith(status: ReviewsStatus.loading));
    final result = await getMyReviewsUseCase.execute();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ReviewsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: ReviewsStatus.success,
          summary: data.summary,
          allReviews: data.reviews,
          filteredReviews: data.reviews,
          clearFilter: true,
        ),
      ),
    );
  }

  void filterByRating(int? rating) {
    if (rating == null) {
      // Show all reviews
      emit(
        state.copyWith(filteredReviews: state.allReviews, clearFilter: true),
      );
    } else {
      // Filter by specific rating
      final filtered = state.allReviews
          .where((review) => review.rating == rating)
          .toList();
      emit(
        state.copyWith(filteredReviews: filtered, selectedRatingFilter: rating),
      );
    }
  }
}
