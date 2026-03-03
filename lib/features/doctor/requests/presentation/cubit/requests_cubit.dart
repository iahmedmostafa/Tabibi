import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/doctor/requests/domain/entities/appointment_request.dart';
import 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit() : super(const RequestsState()) {
    _loadMockData();
  }

  void _loadMockData() {
    final now = DateTime.now();
    final mockRequests = [
      AppointmentRequest(
        id: '1',
        patientName: 'Jennifer Smith',
        dateTime: DateTime(now.year, now.month, now.day, 10, 0),
        reason: 'Persistent headaches for the past week, need consultation',
      ),
      AppointmentRequest(
        id: '2',
        patientName: 'Robert Brown',
        dateTime: DateTime(now.year, now.month, now.day, 14, 30),
        reason: 'Follow-up for recent surgery, wound check required',
      ),
      AppointmentRequest(
        id: '3',
        patientName: 'Maria Garcia',
        dateTime: DateTime(now.year, now.month, now.day + 1, 9, 15),
        reason: 'Annual physical examination and blood work',
      ),
      AppointmentRequest(
        id: '4',
        patientName: 'David Wilson',
        dateTime: DateTime(now.year, now.month, now.day + 2, 11, 0),
        reason: 'Consultation regarding new medication side effects',
      ),
    ];

    emit(
      state.copyWith(allRequests: mockRequests, filteredRequests: mockRequests),
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

  void approveRequest(String id) {
    final updatedList = state.allRequests.where((r) => r.id != id).toList();
    emit(state.copyWith(allRequests: updatedList));
    _applyFilters();
  }

  void rejectRequest(String id) {
    final updatedList = state.allRequests.where((r) => r.id != id).toList();
    emit(state.copyWith(allRequests: updatedList));
    _applyFilters();
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
          final rDate = DateTime(
            r.dateTime.year,
            r.dateTime.month,
            r.dateTime.day,
          );
          return rDate.isAfter(today);
        }).toList();
        break;
      case RequestFilter.all:
      default:
        break;
    }

    emit(state.copyWith(filteredRequests: filtered));
  }
}
