import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/home/data/repositories/doctor_repository.dart';
import '../../../../data/models/doctor_model.dart';
import 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  DoctorsCubit(this.repository) : super(const DoctorsState());

  final DoctorsRepository repository;

  Future<void> getAllDoctors({String? initialDepartment}) async {
    emit(state.copyWith(status: DoctorsStatus.loading));

    final result = await repository.getDoctors();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DoctorsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (doctors) {
        List<DoctorModel> filtered = doctors;
        if (initialDepartment != null) {
          filtered = doctors
              .where((doctor) => doctor.departmentName == initialDepartment)
              .toList();
        }
        emit(
          state.copyWith(
            status: DoctorsStatus.success,
            allDoctors: doctors,
            filteredDoctors: filtered,
          ),
        );
      },
    );
  }

  void filterByDepartmentName(String departmentName) {
    final filtered = state.allDoctors
        .where((doctor) => doctor.departmentName == departmentName)
        .toList();

    emit(state.copyWith(filteredDoctors: filtered));
  }

  void showAllDoctors() {
    emit(state.copyWith(filteredDoctors: state.allDoctors));
  }
}
