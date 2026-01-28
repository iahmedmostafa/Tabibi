part of 'departments_cubit.dart';

class DepartmentsState extends Equatable {
  final DepartmentsStatus departmentsStatus;
  final List<Department>? departments;
  final String? errorMessage;

  const DepartmentsState({
    this.departmentsStatus = DepartmentsStatus.initial,
    this.departments = const [],
    this.errorMessage,
  });

  DepartmentsState copyWith({
    DepartmentsStatus? departmentsStatus,
    List<Department>? departments,
    String? errorMessage,
  }) {
    return DepartmentsState(
      departmentsStatus: departmentsStatus ?? this.departmentsStatus,
      departments: departments ?? this.departments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [departmentsStatus, departments, errorMessage];
}
