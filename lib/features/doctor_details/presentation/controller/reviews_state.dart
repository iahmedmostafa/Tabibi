import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor_details/domain/entities/doctor_details_entity.dart';

abstract class ReviewsState extends Equatable {
  const ReviewsState();

  @override
  List<Object?> get props => [];
}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsSuccess extends ReviewsState {
  final List<DoctorReview> reviews;
  final bool hasNextPage;

  const ReviewsSuccess({required this.reviews, required this.hasNextPage});

  @override
  List<Object?> get props => [reviews, hasNextPage];
}

class ReviewsFailure extends ReviewsState {
  final String message;

  const ReviewsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ReviewsPaginationLoading extends ReviewsState {
  final List<DoctorReview> reviews;

  const ReviewsPaginationLoading(this.reviews);

  @override
  List<Object?> get props => [reviews];
}
