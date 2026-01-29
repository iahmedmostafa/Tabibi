import 'package:tabibi/features/home/data/models/work_schedule_dto.dart';

class DoctorFillProfileFormState {
  final int currentPage;
  final String? selectedBirthdate;
  final String? selectedDoctorCityId;
  final String? selectedDepartmentId;
  final String? selectedClinicCityId;
  final double? clinicLatitude;
  final double? clinicLongitude;
  final int gender;
  final List<WorkScheduleDto> schedules;

  const DoctorFillProfileFormState({
    this.currentPage = 0,
    this.selectedBirthdate,
    this.selectedDoctorCityId,
    this.selectedDepartmentId,
    this.selectedClinicCityId,
    this.clinicLatitude,
    this.clinicLongitude,
    this.gender = 0,
    this.schedules = const [],
  });

  DoctorFillProfileFormState copyWith({
    int? currentPage,
    String? selectedBirthdate,
    String? selectedDoctorCityId,
    String? selectedDepartmentId,
    String? selectedClinicCityId,
    double? clinicLatitude,
    double? clinicLongitude,
    int? gender,
    List<WorkScheduleDto>? schedules,
  }) {
    return DoctorFillProfileFormState(
      currentPage: currentPage ?? this.currentPage,
      selectedBirthdate: selectedBirthdate ?? this.selectedBirthdate,
      selectedDoctorCityId: selectedDoctorCityId ?? this.selectedDoctorCityId,
      selectedDepartmentId: selectedDepartmentId ?? this.selectedDepartmentId,
      selectedClinicCityId: selectedClinicCityId ?? this.selectedClinicCityId,
      clinicLatitude: clinicLatitude ?? this.clinicLatitude,
      clinicLongitude: clinicLongitude ?? this.clinicLongitude,
      gender: gender ?? this.gender,
      schedules: schedules ?? this.schedules,
    );
  }
}
