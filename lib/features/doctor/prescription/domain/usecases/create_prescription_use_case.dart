import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/doctor/prescription/domain/entities/create_prescription_request.dart';
import 'package:tabibi/features/doctor/prescription/domain/repositories/doctor_prescription_repository.dart';

class CreatePrescriptionUseCase
    extends BaseUseCase<void, CreatePrescriptionParameters> {
  final DoctorPrescriptionRepository repository;

  CreatePrescriptionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(
    CreatePrescriptionParameters parameters,
  ) async {
    return repository.createPrescription(
      appointmentId: parameters.appointmentId,
      request: parameters.request,
    );
  }
}

class CreatePrescriptionParameters extends Equatable {
  final String appointmentId;
  final CreatePrescriptionRequest request;

  const CreatePrescriptionParameters({
    required this.appointmentId,
    required this.request,
  });

  @override
  List<Object?> get props => [appointmentId, request];
}
