import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/home/data/repositories/doctor_repository.dart';
import 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  DoctorsCubit(this.repository) : super(const DoctorsState());

  final DoctorsRepository repository;
  String? _currentDepartmentId;
  String? _currentQuery;

  /// Fetches the first page of doctors with optional filters
  Future<void> getDoctors({String? departmentId, String? query}) async {
    _currentDepartmentId = departmentId;
    _currentQuery = query;

    emit(
      state.copyWith(
        status: DoctorsStatus.loading,
        page: 1,
        hasReachedMax: false,
        doctors: [],
      ),
    );

    final result = await repository.getDoctors(
      page: 1,
      departmentId: departmentId,
      query: query,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DoctorsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (response) {
        emit(
          state.copyWith(
            status: DoctorsStatus.success,
            doctors: response.items,
            hasReachedMax: !response.hasNextPage,
            page: 1,
          ),
        );
      },
    );
  }

  /// Loads the next page of doctors
  Future<void> loadMoreDoctors() async {
    if (state.hasReachedMax || state.isMoreLoading) return;

    emit(state.copyWith(isMoreLoading: true));

    final nextPage = state.page + 1;
    final result = await repository.getDoctors(
      page: nextPage,
      departmentId: _currentDepartmentId,
      query: _currentQuery,
    );

    result.fold((failure) => emit(state.copyWith(isMoreLoading: false)), (
      response,
    ) {
      emit(
        state.copyWith(
          isMoreLoading: false,
          doctors: List.of(state.doctors)..addAll(response.items),
          hasReachedMax: !response.hasNextPage,
          page: nextPage,
        ),
      );
    });
  }

  /// Filters doctors by department ID
  void filterByDepartmentId(String? departmentId) {
    getDoctors(departmentId: departmentId);
  }
}
