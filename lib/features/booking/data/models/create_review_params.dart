class CreateReviewParams {
  final String bookingId;
  final int rating;
  final String? comment;

  const CreateReviewParams({
    required this.bookingId,
    required this.rating,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'rating': rating,
      'comment': comment?.trim().isEmpty == true ? null : comment?.trim(),
    };
  }
}
