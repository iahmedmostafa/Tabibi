import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/home/data/models/department_model.dart';
import 'package:tabibi/features/home/data/repositories/department_repo.dart';

class GetDepartmentsUseCase {
  final DepartmentRepository repository;

  GetDepartmentsUseCase(this.repository);

  Future<Either<Failure, DepartmentModel>> call() async {
    return await repository.getDepartments();
  }
}
