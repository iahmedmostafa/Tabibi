import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/doctor/requests/domain/entities/appointment_request.dart';
import 'package:tabibi/features/doctor/requests/domain/usecases/requests_usecases.dart';
import 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  final GetAppointmentRequestsUseCase getAppointmentRequestsUseCase;
  final ApproveAppointmentUseCase approveAppointmentUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;

  RequestsCubit(
    this.getAppointmentRequestsUseCase,
    this.approveAppointmentUseCase,
    this.cancelAppointmentUseCase,
  ) : super(const RequestsState()) {
    getRequests();
  }

  Future<void> getRequests() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await getAppointmentRequestsUseCase(const NoParameters());
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (data) {
        emit(state.copyWith(
          isLoading: false,
          allRequests: data,
        ));
        _applyFilters();
      },
    );
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
    _applyFilters();
  }

  void setFilter(RequestFilter filter) {
    emit(state.copyWith(selectedFilter: filter));
    _applyFilters();
  }

  Future<void> approveRequest(String id, {Function? onSuccess, Function(String)? onError}) async {
    emit(state.copyWith(isActionLoading: true, errorMessage: null));
    final result = await approveAppointmentUseCase(id);
    result.fold(
      (failure) {
        emit(state.copyWith(isActionLoading: false, errorMessage: failure.message));
        if (onError != null) onError(failure.message);
      },
      (_) {
        final updatedList = state.allRequests.map((r) => r.id == id ? r.copyWith(status: 'approved') : r).toList();
        emit(state.copyWith(isActionLoading: false, allRequests: updatedList));
        _applyFilters();
        if (onSuccess != null) onSuccess();
      },
    );
  }

  Future<void> rejectRequest(String id, {Function? onSuccess, Function(String)? onError}) async {
    emit(state.copyWith(isActionLoading: true, errorMessage: null));
    final result = await cancelAppointmentUseCase(id);
    result.fold(
      (failure) {
        emit(state.copyWith(isActionLoading: false, errorMessage: failure.message));
        if (onError != null) onError(failure.message);
      },
      (_) {
        final updatedList = state.allRequests.map((r) => r.id == id ? r.copyWith(status: 'rejected') : r).toList();
        emit(state.copyWith(isActionLoading: false, allRequests: updatedList));
        _applyFilters();
        if (onSuccess != null) onSuccess();
      },
    );
  }

  void _applyFilters() {
    List<AppointmentRequest> filtered = state.allRequests;

    // 1. Apply Search
    if (state.searchQuery.isNotEmpty) {
      filtered = filtered.where((r) {
        return r.patientName.toLowerCase().contains(
          state.searchQuery.toLowerCase(),
        );
      }).toList();
    }

    // 2. Apply Category Filter
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (state.selectedFilter) {
      case RequestFilter.today:
        filtered = filtered.where((r) {
          final rDate = DateTime(
            r.dateTime.year,
            r.dateTime.month,
            r.dateTime.day,
          );
          return rDate.isAtSameMomentAs(today);
        }).toList();
        break;
      case RequestFilter.upcoming:
        filtered = filtered.where((r) {
          return r.dateTime.isAfter(DateTime.now());
        }).toList();
        break;
      case RequestFilter.all:
        break;
    }

    emit(state.copyWith(filteredRequests: filtered));
  }
}
