import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/log_out_use_case.dart';
import 'package:tabibi/features/patient_profile/domain/usecases/get_patient_profile_use_case.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final LogOutUseCase logOutUseCase;
  final GetPatientProfileUseCase getPatientProfileUseCase;

  ProfileCubit({
    required this.logOutUseCase,
    required this.getPatientProfileUseCase,
  }) : super(ProfileInitial());

  Future<void> logOut() async {
    emit(LogOutLoading());
    final result = await logOutUseCase(const NoParameters());
    result.fold(
      (l) => emit(LogOutError(l.message)),
      (r) => emit(LogOutSuccess()),
    );
  }

  Future<void> getProfile() async {
    emit(ProfileLoading());
    final result = await getPatientProfileUseCase();
    result.fold(
      (l) => emit(ProfileError(l.message)),
      (r) => emit(ProfileLoaded(r)),
    );
  }
}
