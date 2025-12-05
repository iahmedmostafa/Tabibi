import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/doctor_fill_profile_form_state.dart';
import 'package:tabibi/features/home/data/models/work_schedule_dto.dart';

class DoctorFillProfileFormCubit extends Cubit<DoctorFillProfileFormState> {
  DoctorFillProfileFormCubit() : super(const DoctorFillProfileFormState());

  // Page navigation
  void setCurrentPage(int page) {
    emit(state.copyWith(currentPage: page));
  }

  void nextPage() {
    if (state.currentPage < 3) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  // Form field updates
  void setGender(int gender) {
    emit(state.copyWith(gender: gender));
  }

  void setBirthdate(String? date) {
    emit(state.copyWith(selectedBirthdate: date));
  }

  void setDoctorCity(String? cityId) {
    emit(state.copyWith(selectedDoctorCityId: cityId));
  }

  void setDepartment(String? departmentId) {
    emit(state.copyWith(selectedDepartmentId: departmentId));
  }

  void setClinicCity(String? cityId) {
    emit(state.copyWith(selectedClinicCityId: cityId));
  }

  void setSchedules(List<WorkScheduleDto> schedules) {
    emit(state.copyWith(schedules: schedules));
  }

  // Reset form
  void reset() {
    emit(const DoctorFillProfileFormState());
  }
}
