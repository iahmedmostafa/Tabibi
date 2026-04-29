import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/booking/data/models/create_review_params.dart';
import 'package:tabibi/features/booking/domain/usecases/create_review_use_case.dart';

part 'add_review_state.dart';

class AddReviewCubit extends Cubit<AddReviewState> {
  final CreateReviewUseCase createReviewUseCase;

  AddReviewCubit(this.createReviewUseCase) : super(const AddReviewState());

  Future<void> submit({
    required String bookingId,
    required int rating,
    String? comment,
  }) async {
    emit(state.copyWith(status: AddReviewStatus.loading, errorMessage: null));

    final result = await createReviewUseCase.execute(
      CreateReviewParams(
        bookingId: bookingId,
        rating: rating,
        comment: comment,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AddReviewStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: AddReviewStatus.success)),
    );
  }
}
