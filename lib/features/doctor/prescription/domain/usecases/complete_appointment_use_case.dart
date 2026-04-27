import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/doctor/prescription/domain/repositories/doctor_prescription_repository.dart';

class CompleteAppointmentUseCase extends BaseUseCase<void, String> {
  final DoctorPrescriptionRepository repository;

  CompleteAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String parameters) async {
    return repository.completeAppointment(appointmentId: parameters);
  }
}
