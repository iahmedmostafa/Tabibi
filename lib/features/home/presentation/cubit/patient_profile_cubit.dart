import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/home/domain/usecases/get_patient_profile_use_case.dart';
import 'package:tabibi/features/home/presentation/cubit/patient_profile_state.dart';

class PatientProfileCubit extends Cubit<PatientProfileState> {
  final GetPatientProfileUseCase getPatientProfileUseCase;

  PatientProfileCubit(this.getPatientProfileUseCase)
    : super(const PatientProfileState());

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
}
