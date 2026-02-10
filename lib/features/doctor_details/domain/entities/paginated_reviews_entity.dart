import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor_details/domain/entities/doctor_details_entity.dart';

class PaginatedReviews extends Equatable {
  final List<DoctorReview> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const PaginatedReviews({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [
    items,
    page,
    pageSize,
    totalCount,
    totalPages,
    hasPreviousPage,
    hasNextPage,
  ];
}
