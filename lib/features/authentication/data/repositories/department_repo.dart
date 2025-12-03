import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/authentication/data/datasources/departments_data_source.dart';
import 'package:tabibi/features/authentication/data/models/department_model.dart';

class DepartmentRepository {
  final DepartmentsDataSource departmentsDataSource;

  DepartmentRepository(this.departmentsDataSource);

  Future<Either<Failure, List<DepartmentModel>>> getDepartments() async {
    try {
      final List<DepartmentModel> departments = await departmentsDataSource.getDepartments();

      return Right(departments);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.formattedErrors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
