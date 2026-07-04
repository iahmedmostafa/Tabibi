import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/doctor/prescription/domain/entities/create_prescription_request.dart';
import 'package:tabibi/features/doctor/prescription/domain/entities/prescription_medicine.dart';
import 'package:tabibi/features/doctor/prescription/domain/usecases/complete_appointment_use_case.dart';
import 'package:tabibi/features/doctor/prescription/domain/usecases/create_prescription_use_case.dart';
import 'package:tabibi/features/doctor/prescription/presentation/cubit/create_prescription_state.dart';
import 'package:easy_localization/easy_localization.dart';

class CreatePrescriptionCubit extends Cubit<CreatePrescriptionState> {
  final CreatePrescriptionUseCase createPrescriptionUseCase;
  final CompleteAppointmentUseCase completeAppointmentUseCase;
  int _medicineIdSeed = 1;

  CreatePrescriptionCubit(
    this.createPrescriptionUseCase,
    this.completeAppointmentUseCase,
  ) : super(const CreatePrescriptionState());

  void initialize({required String appointmentId, DateTime? appointmentDate}) {
    emit(
      state.copyWith(
        appointmentId: appointmentId,
        appointmentDate: appointmentDate,
      ),
    );
  }

  void diagnosisChanged(String value) {
    emit(state.copyWith(diagnosis: value, errorMessage: null));
  }

  void notesChanged(String value) {
    emit(state.copyWith(notes: value, errorMessage: null));
  }

  void addMedicine() {
    emit(
      state.copyWith(
        medicines: [
          ...state.medicines,
          PrescriptionMedicineFormInput(id: 'medicine-${_medicineIdSeed++}'),
        ],
        errorMessage: null,
      ),
    );
  }

  void removeMedicine(int index) {
    if (!state.canRemoveMedicine ||
        index < 0 ||
        index >= state.medicines.length) {
      return;
    }

    final medicines = [...state.medicines]..removeAt(index);
    emit(state.copyWith(medicines: medicines, errorMessage: null));
  }

  void medicineChanged(
    int index, {
    String? medicineName,
    String? dosage,
    String? frequency,
    String? duration,
    String? instructions,
  }) {
    if (index < 0 || index >= state.medicines.length) return;

    final medicines = [...state.medicines];
    medicines[index] = medicines[index].copyWith(
      medicineName: medicineName,
      dosage: dosage,
      frequency: frequency,
      duration: duration,
      instructions: instructions,
    );
    emit(state.copyWith(medicines: medicines, errorMessage: null));
  }

  Future<void> submit() async {
    if (state.status == CreatePrescriptionStatus.loading) return;
    if (!state.isAppointmentAvailable) {
      emit(
        state.copyWith(
          status: CreatePrescriptionStatus.unavailable,
          errorMessage: 'prescriptionAfterVisit'.tr(),
        ),
      );
      return;
    }
    if (!state.canSubmit) {
      emit(
        state.copyWith(
          status: CreatePrescriptionStatus.validationFailure,
          errorMessage: 'pleaseCompleteDiagnosis'.tr(),
        ),
      );
      return;
    }

    final medicines = state.medicines
        .map(
          (medicine) => PrescriptionMedicine(
            medicineName: medicine.medicineName.trim(),
            dosage: medicine.dosage.trim(),
            frequency: medicine.frequency.trim(),
            duration: medicine.duration.trim(),
            instructions: medicine.instructions.trim(),
          ),
        )
        .toList();

    emit(
      state.copyWith(
        status: CreatePrescriptionStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await createPrescriptionUseCase(
      CreatePrescriptionParameters(
        appointmentId: state.appointmentId,
        request: CreatePrescriptionRequest(
          diagnosis: state.diagnosis.trim(),
          notes: state.notes.trim().isEmpty ? null : state.notes.trim(),
          medicines: medicines,
        ),
      ),
    );

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: CreatePrescriptionStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) async {
        final completeResult = await completeAppointmentUseCase(
          state.appointmentId,
        );

        completeResult.fold(
          (failure) => emit(
            state.copyWith(
              status: CreatePrescriptionStatus.completionFailure,
              errorMessage: 'prescriptionSaveFailed'.tr(
                namedArgs: {'message': failure.message},
              ),
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
