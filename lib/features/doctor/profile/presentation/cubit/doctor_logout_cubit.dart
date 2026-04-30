import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/log_out_use_case.dart';
import 'package:tabibi/features/doctor/profile/presentation/cubit/doctor_logout_state.dart';

class DoctorLogoutCubit extends Cubit<DoctorLogoutState> {
  final LogOutUseCase logOutUseCase;

  DoctorLogoutCubit(this.logOutUseCase) : super(DoctorLogoutInitial());

  Future<void> logOut() async {
    if (state is DoctorLogoutLoading) return;

    emit(DoctorLogoutLoading());
    final result = await logOutUseCase(const NoParameters());
    result.fold(
      (failure) => emit(DoctorLogoutError(failure.message)),
      (_) => emit(DoctorLogoutSuccess()),
    );
  }
}
