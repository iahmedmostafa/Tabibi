import 'package:tabibi/features/doctor_details/data/models/doctor_details_model.dart';
import 'package:tabibi/features/doctor_details/domain/entities/paginated_reviews_entity.dart';

class PaginatedReviewsModel extends PaginatedReviews {
  const PaginatedReviewsModel({
    required List<ReviewModel> super.items,
    required super.page,
    required super.pageSize,
    required super.totalCount,
    required super.totalPages,
    required super.hasPreviousPage,
    required super.hasNextPage,
  });

  factory PaginatedReviewsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedReviewsModel(
      items: (json['items'] as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList(),
      page: json['page'],
      pageSize: json['pageSize'],
      totalCount: json['totalCount'],
      totalPages: json['totalPages'],
      hasPreviousPage: json['hasPreviousPage'],
      hasNextPage: json['hasNextPage'],
    );
  }
}
