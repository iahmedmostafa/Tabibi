import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/home/data/models/update_patient_profile_params.dart';
import 'package:tabibi/features/home/domain/usecases/get_patient_profile_use_case.dart';
import 'package:tabibi/features/home/domain/usecases/update_patient_profile_use_case.dart';
import 'package:tabibi/features/home/presentation/cubit/patient_profile_state.dart';

class PatientProfileCubit extends Cubit<PatientProfileState> {
  final GetPatientProfileUseCase getPatientProfileUseCase;
  final UpdatePatientProfileUseCase updatePatientProfileUseCase;

  PatientProfileCubit(
    this.getPatientProfileUseCase,
    this.updatePatientProfileUseCase,
  ) : super(const PatientProfileState());

  Future<void> getPatientProfile() async {
    emit(state.copyWith(status: PatientProfileStatus.loading));

    final result = await getPatientProfileUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PatientProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (profile) => emit(
        state.copyWith(status: PatientProfileStatus.success, profile: profile),
      ),
    );
  }

  Future<void> updatePatientProfile(UpdatePatientProfileParams params) async {
    emit(state.copyWith(updateStatus: PatientProfileUpdateStatus.loading));

    final result = await updatePatientProfileUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          updateStatus: PatientProfileUpdateStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          updateStatus: PatientProfileUpdateStatus.success,
          updateMessage: message,
        ),
      ),
    );
  }
}
