import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/doctor/requests/domain/entities/appointment_request.dart';
import 'package:tabibi/features/doctor/requests/domain/repositories/requests_repository.dart';

class GetAppointmentRequestsUseCase extends BaseUseCase<List<AppointmentRequest>, NoParameters> {
  final RequestsRepository repository;

  GetAppointmentRequestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentRequest>>> call(NoParameters parameters) async {
    return await repository.getAppointmentRequests();
  }
}

class ApproveAppointmentUseCase extends BaseUseCase<void, String> {
  final RequestsRepository repository;

  ApproveAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String parameters) async {
    return await repository.approveAppointment(parameters);
  }
}

class CancelAppointmentUseCase extends BaseUseCase<void, String> {
  final RequestsRepository repository;

  CancelAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String parameters) async {
    return await repository.cancelAppointment(parameters);
  }
}
