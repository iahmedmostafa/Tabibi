import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/doctor/reviews/domain/entities/review.dart';
import 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit()
    : super(
        ReviewsState(
          summary: const RatingSummary(
            averageRating: 4.9,
            totalReviews: 151,
            ratingDistribution: {5: 124, 4: 18, 3: 6, 2: 2, 1: 1},
          ),
          allReviews: _mockReviews,
          filteredReviews: _mockReviews,
        ),
      );

  static final List<Review> _mockReviews = [
    Review(
      id: '1',
      patientName: 'Sarah Johnson',
      date: DateTime(2025, 11, 20),
      rating: 5,
      comment:
          'Dr. Miller is excellent! Very professional and took time to explain everything clearly. Highly recommended!',
      helpfulCount: 12,
    ),
    Review(
      id: '2',
      patientName: 'Michael Chen',
      date: DateTime(2025, 11, 18),
      rating: 5,
      comment:
          'Outstanding service! Dr. Miller addressed all my concerns and provided excellent care.',
      helpfulCount: 8,
    ),
    Review(
      id: '3',
      patientName: 'Emily Parker',
      date: DateTime(2025, 11, 15),
      rating: 4,
      comment:
          'Good consultation overall. The doctor was thorough but had to wait a bit longer than expected.',
      helpfulCount: 5,
    ),
    Review(
      id: '4',
      patientName: 'James Wilson',
      date: DateTime(2025, 11, 12),
      rating: 5,
      comment:
          'Outstanding service! Dr. Miller addressed all my concerns and provided excellent care.',
      helpfulCount: 15,
    ),
    Review(
      id: '5',
      patientName: 'Lisa Anderson',
      date: DateTime(2025, 11, 10),
      rating: 4,
      comment:
          'Very professional and knowledgeable. Would definitely recommend to others.',
      helpfulCount: 6,
    ),
    Review(
      id: '6',
      patientName: 'Robert Brown',
      date: DateTime(2025, 11, 8),
      rating: 5,
      comment: 'Excellent doctor! Very caring and attentive to patient needs.',
      helpfulCount: 10,
    ),
    Review(
      id: '7',
      patientName: 'Jennifer Davis',
      date: DateTime(2025, 11, 5),
      rating: 3,
      comment:
          'Decent experience. The consultation was okay but nothing exceptional.',
      helpfulCount: 3,
    ),
  ];

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
