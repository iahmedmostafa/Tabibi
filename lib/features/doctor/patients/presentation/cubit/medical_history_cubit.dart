import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/doctor/patients/domain/usecases/get_patient_medical_profile_use_case.dart';
import 'medical_history_state.dart';

class MedicalHistoryCubit extends Cubit<MedicalHistoryState> {
  final GetPatientMedicalProfileUseCase _getMedicalProfileUseCase;

  MedicalHistoryCubit(this._getMedicalProfileUseCase)
    : super(const MedicalHistoryState());

  Future<void> getMedicalProfile(String patientId) async {
    emit(state.copyWith(status: MedicalHistoryStatus.loading));

    final result = await _getMedicalProfileUseCase(patientId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: MedicalHistoryStatus.error,
        errorMessage: failure.message,
      )),
      (profile) => emit(state.copyWith(
        status: MedicalHistoryStatus.success,
        profile: profile,
      )),
    );
  }
}
