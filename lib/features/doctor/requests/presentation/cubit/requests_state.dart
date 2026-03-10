import 'package:equatable/equatable.dart';
import 'package:tabibi/features/doctor/requests/domain/entities/appointment_request.dart';

enum RequestFilter { all, today, upcoming }

class RequestsState extends Equatable {
  final List<AppointmentRequest> allRequests;
  final List<AppointmentRequest> filteredRequests;
  final RequestFilter selectedFilter;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;
  final bool isActionLoading;

  const RequestsState({
    this.allRequests = const [],
    this.filteredRequests = const [],
    this.selectedFilter = RequestFilter.all,
    this.searchQuery = '',
    this.isLoading = false,
    this.errorMessage,
    this.isActionLoading = false,
  });

  RequestsState copyWith({
    List<AppointmentRequest>? allRequests,
    List<AppointmentRequest>? filteredRequests,
    RequestFilter? selectedFilter,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
    bool? isActionLoading,
  }) {
    return RequestsState(
      allRequests: allRequests ?? this.allRequests,
      filteredRequests: filteredRequests ?? this.filteredRequests,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isActionLoading: isActionLoading ?? this.isActionLoading,
    );
  }

  @override
  List<Object?> get props => [
    allRequests,
    filteredRequests,
    selectedFilter,
    searchQuery,
    isLoading,
    errorMessage,
    isActionLoading,
  ];
}
