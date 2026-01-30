import 'package:equatable/equatable.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import '../../../../data/models/doctor_model.dart';

class DoctorsState extends Equatable {
  final DoctorsStatus status;
  final List<DoctorModel> doctors;
  final String? errorMessage;
  final bool hasReachedMax;
  final int page;
  final bool isMoreLoading;

  const DoctorsState({
    this.status = DoctorsStatus.initial,
    this.doctors = const [],
    this.errorMessage,
    this.hasReachedMax = false,
    this.page = 1,
    this.isMoreLoading = false,
  });

  DoctorsState copyWith({
    DoctorsStatus? status,
    List<DoctorModel>? doctors,
    String? errorMessage,
    bool? hasReachedMax,
    int? page,
    bool? isMoreLoading,
  }) {
    return DoctorsState(
      status: status ?? this.status,
      doctors: doctors ?? this.doctors,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
    );
  }

  /// Backward compatibility getters
  List<DoctorModel> get filteredDoctors => doctors;
  List<DoctorModel> get allDoctors => doctors;

  @override
  List<Object?> get props => [
    status,
    doctors,
    errorMessage,
    hasReachedMax,
    page,
    isMoreLoading,
  ];
}
