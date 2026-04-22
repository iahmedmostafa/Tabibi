import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/dashboard_response.dart';
import 'package:tabibi/features/doctor/dashboard/domain/repositories/dashboard_repository.dart';

class GetDoctorDashboardUseCase
    extends BaseUseCase<DashboardResponse, NoParameters> {
  final DashboardRepository repository;

  GetDoctorDashboardUseCase(this.repository);

  @override
  Future<Either<Failure, DashboardResponse>> call(
    NoParameters parameters,
  ) async {
    return await repository.getDoctorDashboard();
  }
}
