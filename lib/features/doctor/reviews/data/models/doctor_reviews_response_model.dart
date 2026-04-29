import 'package:tabibi/features/doctor/reviews/domain/entities/review.dart';

class DoctorReviewsResponseModel {
  final RatingSummary summary;
  final List<Review> reviews;

  const DoctorReviewsResponseModel({
    required this.summary,
    required this.reviews,
  });

  factory DoctorReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    final reviewsJson = json['reviews'];
    final items = reviewsJson is Map ? reviewsJson['items'] : null;

    return DoctorReviewsResponseModel(
      summary: RatingSummaryModel.fromJson(
        json['stats'] is Map
            ? Map<String, dynamic>.from(json['stats'] as Map)
            : const {},
      ),
      reviews: items is List
          ? items
                .whereType<Map>()
                .map((e) => ReviewModel.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : const [],
    );
  }
}

class RatingSummaryModel extends RatingSummary {
  const RatingSummaryModel({
    required super.averageRating,
    required super.totalReviews,
    required super.ratingDistribution,
  });

  factory RatingSummaryModel.fromJson(Map<String, dynamic> json) {
    return RatingSummaryModel(
      averageRating: _toDouble(json['averageRating']),
      totalReviews: _toInt(json['totalReviews']),
      ratingDistribution: {
        5: _toInt(json['fiveStarCount']),
        4: _toInt(json['fourStarCount']),
        3: _toInt(json['threeStarCount']),
        2: _toInt(json['twoStarCount']),
        1: _toInt(json['oneStarCount']),
      },
    );
  }
}

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.patientName,
    required super.date,
    required super.rating,
    required super.comment,
    required super.helpfulCount,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      patientName: json['patientName']?.toString() ?? 'Unknown Patient',
      date: _toDate(json['createdAt']),
      rating: _toInt(json['rating']),
      comment: json['comment']?.toString() ?? '',
      helpfulCount: _toInt(json['helpfulCount']),
    );
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

DateTime _toDate(dynamic value) {
  final raw = value?.toString();
  if (raw == null || raw.isEmpty) return DateTime.now();
  return DateTime.tryParse(raw.endsWith('Z') ? raw : '${raw}Z')?.toLocal() ??
      DateTime.now();
}
