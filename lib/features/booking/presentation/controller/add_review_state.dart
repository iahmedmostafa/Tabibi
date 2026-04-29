part of 'add_review_cubit.dart';

enum AddReviewStatus { initial, loading, success, failure }

class AddReviewState extends Equatable {
  final AddReviewStatus status;
  final String? errorMessage;

  const AddReviewState({
    this.status = AddReviewStatus.initial,
    this.errorMessage,
  });

  AddReviewState copyWith({
    AddReviewStatus? status,
    String? errorMessage,
  }) {
    return AddReviewState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
