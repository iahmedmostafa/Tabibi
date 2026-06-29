import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/patient_profile/data/models/update_medical_profile_params.dart';
import 'package:tabibi/features/patient_profile/domain/usecases/get_medical_profile_use_case.dart';
import 'package:tabibi/features/patient_profile/domain/usecases/update_medical_profile_use_case.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/medical_profile_state.dart';

class MedicalProfileCubit extends Cubit<MedicalProfileState> {
  final GetMedicalProfileUseCase getMedicalProfileUseCase;
  final UpdateMedicalProfileUseCase updateMedicalProfileUseCase;

  MedicalProfileCubit(
    this.getMedicalProfileUseCase,
    this.updateMedicalProfileUseCase,
  ) : super(const MedicalProfileState());

  Future<void> getMedicalProfile() async {
    emit(state.copyWith(status: MedicalProfileStatus.loading));

    final result = await getMedicalProfileUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MedicalProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (profile) => emit(
        state.copyWith(status: MedicalProfileStatus.success, profile: profile),
      ),
    );
  }

  Future<void> updateMedicalProfile(
    UpdateMedicalProfileParams params,
  ) async {
    emit(state.copyWith(updateStatus: MedicalProfileUpdateStatus.loading));

    final result = await updateMedicalProfileUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          updateStatus: MedicalProfileUpdateStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          updateStatus: MedicalProfileUpdateStatus.success,
          updateMessage: message,
        ),
      ),
    );
  }
}
