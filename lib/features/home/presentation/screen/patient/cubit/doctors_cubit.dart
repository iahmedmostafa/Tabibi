import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/home/data/models/doctors_filter_params.dart';
import 'package:tabibi/features/home/data/repositories/doctor_repository.dart';
import 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  DoctorsCubit(this.repository) : super(const DoctorsState());

  final DoctorsRepository repository;
  DoctorsFilterParams _currentFilters = const DoctorsFilterParams();

  /// Fetches the first page of doctors with optional filters
  Future<void> getDoctors({
    String? departmentId,
    String? query,
    int? gender,
    String? cityId,
    String? sort,
    String? fields,
    int? pageSize,
    DoctorsFilterParams? filters,
  }) async {
    _currentFilters =
        filters ??
        _currentFilters.copyWith(
          departmentId: departmentId,
          query: query,
          gender: gender,
          cityId: cityId,
          sort: sort,
          fields: fields,
          pageSize: pageSize,
          clearDepartment: departmentId == null,
          clearQuery: query == null || query.trim().isEmpty,
          clearGender: gender == null,
          clearCity: cityId == null,
          clearSort: sort == null,
        );

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
      filters: _currentFilters,
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
      filters: _currentFilters,
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
    getDoctors(
      filters: _currentFilters.copyWith(
        departmentId: departmentId,
        clearDepartment: departmentId == null,
      ),
    );
  }

  DoctorsFilterParams get currentFilters => _currentFilters;
}
