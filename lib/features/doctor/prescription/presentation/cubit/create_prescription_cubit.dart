import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/doctor/prescription/domain/entities/create_prescription_request.dart';
import 'package:tabibi/features/doctor/prescription/domain/entities/prescription_medicine.dart';
import 'package:tabibi/features/doctor/prescription/domain/usecases/complete_appointment_use_case.dart';
import 'package:tabibi/features/doctor/prescription/domain/usecases/create_prescription_use_case.dart';
import 'package:tabibi/features/doctor/prescription/presentation/cubit/create_prescription_state.dart';

class CreatePrescriptionCubit extends Cubit<CreatePrescriptionState> {
  final CreatePrescriptionUseCase createPrescriptionUseCase;
  final CompleteAppointmentUseCase completeAppointmentUseCase;

  CreatePrescriptionCubit(
    this.createPrescriptionUseCase,
    this.completeAppointmentUseCase,
  ) : super(const CreatePrescriptionState());

  Future<void> createPrescription({
    required String appointmentId,
    required String diagnosis,
    String? notes,
    required List<PrescriptionMedicine> medicines,
  }) async {
    if (state.status == CreatePrescriptionStatus.loading) return;

    emit(
      const CreatePrescriptionState(status: CreatePrescriptionStatus.loading),
    );

    final result = await createPrescriptionUseCase(
      CreatePrescriptionParameters(
        appointmentId: appointmentId,
        request: CreatePrescriptionRequest(
          diagnosis: diagnosis.trim(),
          notes: notes?.trim().isEmpty ?? true ? null : notes!.trim(),
          medicines: medicines,
        ),
      ),
    );

    await result.fold(
      (failure) async => emit(
        CreatePrescriptionState(
          status: CreatePrescriptionStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) async {
        final completeResult = await completeAppointmentUseCase(appointmentId);

        completeResult.fold(
          (failure) => emit(
            CreatePrescriptionState(
              status: CreatePrescriptionStatus.completionFailure,
              errorMessage:
                  'Prescription was saved, but appointment completion failed: ${failure.message}',
            ),
          ),
          (_) => emit(
            const CreatePrescriptionState(
              status: CreatePrescriptionStatus.success,
            ),
          ),
        );
      },
    );
  }
}
