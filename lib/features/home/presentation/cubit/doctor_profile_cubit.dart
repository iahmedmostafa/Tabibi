import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/home/data/models/UpdateDoctorProfileParams.dart';
import 'package:tabibi/features/home/domain/usecases/doctor_status_use_case.dart';
import 'package:tabibi/features/home/domain/usecases/get_doctor_profile_use_case.dart';
import 'package:tabibi/features/home/domain/usecases/update_doctor_profile_use_case.dart';
import 'package:tabibi/features/home/presentation/cubit/doctor_profile_state.dart';

class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  final GetDoctorProfileUseCase getDoctorProfileUseCase;
  final UpdateDoctorProfileUseCase updateDoctorProfileUseCase;
  final DoctorStatusUseCase doctorStatusUseCase;

  DoctorProfileCubit(
    this.getDoctorProfileUseCase,
    this.updateDoctorProfileUseCase,
    this.doctorStatusUseCase,
  ) : super(const DoctorProfileState());

  Future<void> getDoctorProfile() async {
    emit(state.copyWith(status: DoctorProfileStatus.loading));

    final result = await getDoctorProfileUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DoctorProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (profile) => emit(
        state.copyWith(status: DoctorProfileStatus.success, profile: profile),
      ),
    );
  }

  Future<void> updateDoctorProfile(UpdateDoctorProfileParams params) async {
    emit(state.copyWith(updateStatus: DoctorProfileUpdateStatus.loading));

    final result = await updateDoctorProfileUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          updateStatus: DoctorProfileUpdateStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          updateStatus: DoctorProfileUpdateStatus.success,
          updateMessage: message,
        ),
      ),
    );
  }

  Future<void> getDoctorStatus() async {
    emit(state.copyWith(doctorStatus: DoctorStatusAction.loading));

    final result = await doctorStatusUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          doctorStatus: DoctorStatusAction.failure,
          errorMessage: failure.message,
        ),
      ),
      (doctorStatus) => emit(
        state.copyWith(doctorStatus: DoctorStatusAction.success, newDoctorStatus: doctorStatus),
      ),
    );
  }
}
