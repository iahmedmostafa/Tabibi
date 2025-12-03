import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabibi/features/authentication/data/models/department_model.dart';
import 'package:tabibi/features/authentication/data/repositories/department_repo.dart';

import '../../../../../core/utils/enums/enums.dart';

part 'departments_state.dart';

class DepartmentsCubit extends Cubit<DepartmentsState> {
  DepartmentsCubit(this.departmentRepository) : super(const DepartmentsState());

  final DepartmentRepository departmentRepository;

  Future<void> getDepartments() async {
    emit(state.copyWith(departmentsStatus: DepartmentsStatus.loading));

    final result = await departmentRepository.getDepartments();

    result.fold(
          (failure) =>
          emit(
            state.copyWith(
              departmentsStatus: DepartmentsStatus.failure,
              errorMessage: failure.message,
            ),
          ),
          (departments) =>
          emit(state.copyWith(departmentsStatus: DepartmentsStatus.success,
              departments: departments)),
    );
  }

  void resetState() {
    emit(const DepartmentsState());
  }

}