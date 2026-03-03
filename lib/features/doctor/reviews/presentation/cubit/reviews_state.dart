import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor/reviews/domain/entities/review.dart';

class ReviewsState extends Equatable {
  final RatingSummary summary;
  final List<Review> allReviews;
  final List<Review> filteredReviews;
  final int? selectedRatingFilter; // null = All, 1-5 = specific rating

  const ReviewsState({
    required this.summary,
    required this.allReviews,
    required this.filteredReviews,
    this.selectedRatingFilter,
  });

  ReviewsState copyWith({
    RatingSummary? summary,
    List<Review>? allReviews,
    List<Review>? filteredReviews,
    int? selectedRatingFilter,
    bool clearFilter = false,
  }) {
    return ReviewsState(
      summary: summary ?? this.summary,
      allReviews: allReviews ?? this.allReviews,
      filteredReviews: filteredReviews ?? this.filteredReviews,
      selectedRatingFilter: clearFilter
          ? null
          : (selectedRatingFilter ?? this.selectedRatingFilter),
    );
  }

  @override
  List<Object?> get props => [
    summary,
    allReviews,
    filteredReviews,
    selectedRatingFilter,
  ];
}
