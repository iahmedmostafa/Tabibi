import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/doctor_details/domain/usecases/get_doctor_reviews_use_case.dart';
import 'package:tabibi/features/doctor_details/presentation/controller/reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final GetDoctorReviewsUseCase getDoctorReviewsUseCase;
  int _currentPage = 1;
  bool _isFetching = false;

  ReviewsCubit(this.getDoctorReviewsUseCase) : super(ReviewsInitial());

  Future<void> getReviews(String doctorId) async {
    if (_isFetching) return;
    _isFetching = true;
    _currentPage = 1;

    emit(ReviewsLoading());

    final result = await getDoctorReviewsUseCase.execute(
      GetDoctorReviewsParams(doctorId: doctorId, page: _currentPage),
    );

    result.fold((failure) => emit(ReviewsFailure(failure.message)), (
      paginatedReviews,
    ) {
      _isFetching = false;
      emit(
        ReviewsSuccess(
          reviews: paginatedReviews.items,
          hasNextPage: paginatedReviews.hasNextPage,
        ),
      );
    });
  }

  Future<void> getMoreReviews(String doctorId) async {
    if (_isFetching || state is! ReviewsSuccess) return;

    final currentState = state as ReviewsSuccess;
    if (!currentState.hasNextPage) return;

    _isFetching = true;
    _currentPage++;

    emit(ReviewsPaginationLoading(currentState.reviews));

    final result = await getDoctorReviewsUseCase.execute(
      GetDoctorReviewsParams(doctorId: doctorId, page: _currentPage),
    );

    result.fold(
      (failure) {
        _isFetching = false;
        // Keep existing reviews but show failure or just stop loading
        emit(
          ReviewsSuccess(
            reviews: currentState.reviews,
            hasNextPage: currentState.hasNextPage,
          ),
        );
      },
      (paginatedReviews) {
        _isFetching = false;
        emit(
          ReviewsSuccess(
            reviews: [...currentState.reviews, ...paginatedReviews.items],
            hasNextPage: paginatedReviews.hasNextPage,
          ),
        );
      },
    );
  }
}
