import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String patientName;
  final DateTime date;
  final int rating; // 1-5
  final String comment;
  final int helpfulCount;

  const Review({
    required this.id,
    required this.patientName,
    required this.date,
    required this.rating,
    required this.comment,
    required this.helpfulCount,
  });

  String get initials {
    final parts = patientName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return patientName.substring(0, 2).toUpperCase();
  }

  @override
  List<Object?> get props => [id, patientName, date, rating, comment];
}

class RatingSummary extends Equatable {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // {5: 124, 4: 18, 3: 6, 2: 2, 1: 1}

  const RatingSummary({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  int getRatingCount(int rating) => ratingDistribution[rating] ?? 0;

  double getRatingPercentage(int rating) {
    if (totalReviews == 0) return 0;
    return (getRatingCount(rating) / totalReviews) * 100;
  }

  @override
  List<Object?> get props => [averageRating, totalReviews, ratingDistribution];
}
