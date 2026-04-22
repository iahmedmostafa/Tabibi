import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/doctor/dashboard/domain/entities/dashboard_response.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardResponse>> getDoctorDashboard();
}
