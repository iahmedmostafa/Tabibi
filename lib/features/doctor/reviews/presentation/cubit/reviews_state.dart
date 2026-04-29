import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor/reviews/domain/entities/review.dart';

class ReviewsState extends Equatable {
  final ReviewsStatus status;
  final RatingSummary summary;
  final List<Review> allReviews;
  final List<Review> filteredReviews;
  final int? selectedRatingFilter; // null = All, 1-5 = specific rating
  final String? errorMessage;

  const ReviewsState({
    this.status = ReviewsStatus.initial,
    required this.summary,
    required this.allReviews,
    required this.filteredReviews,
    this.selectedRatingFilter,
    this.errorMessage,
  });

  ReviewsState copyWith({
    ReviewsStatus? status,
    RatingSummary? summary,
    List<Review>? allReviews,
    List<Review>? filteredReviews,
    int? selectedRatingFilter,
    String? errorMessage,
    bool clearFilter = false,
  }) {
    return ReviewsState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      allReviews: allReviews ?? this.allReviews,
      filteredReviews: filteredReviews ?? this.filteredReviews,
      selectedRatingFilter: clearFilter
          ? null
          : (selectedRatingFilter ?? this.selectedRatingFilter),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    summary,
    allReviews,
    filteredReviews,
    selectedRatingFilter,
    errorMessage,
  ];
}

enum ReviewsStatus { initial, loading, success, failure }
