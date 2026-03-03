import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor/requests/domain/entities/appointment_request.dart';

enum RequestFilter { all, today, upcoming }

class RequestsState extends Equatable {
  final List<AppointmentRequest> allRequests;
  final List<AppointmentRequest> filteredRequests;
  final RequestFilter selectedFilter;
  final String searchQuery;

  const RequestsState({
    this.allRequests = const [],
    this.filteredRequests = const [],
    this.selectedFilter = RequestFilter.all,
    this.searchQuery = '',
  });

  RequestsState copyWith({
    List<AppointmentRequest>? allRequests,
    List<AppointmentRequest>? filteredRequests,
    RequestFilter? selectedFilter,
    String? searchQuery,
  }) {
    return RequestsState(
      allRequests: allRequests ?? this.allRequests,
      filteredRequests: filteredRequests ?? this.filteredRequests,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    allRequests,
    filteredRequests,
    selectedFilter,
    searchQuery,
  ];
}
