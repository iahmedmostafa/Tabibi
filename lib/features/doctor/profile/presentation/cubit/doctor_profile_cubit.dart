import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/doctor/profile/domain/repositories/doctor_profile_repository.dart';
import 'package:tabibi/features/doctor/profile/presentation/cubit/doctor_profile_state.dart';

class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  final DoctorProfileRepository repository;

  DoctorProfileCubit(this.repository) : super(DoctorProfileInitial());

  Future<void> fetchDoctorProfile() async {
    emit(DoctorProfileLoading());
    final result = await repository.getDoctorProfile();
    result.fold(
      (failure) => emit(DoctorProfileError(failure.message)),
      (profile) => emit(DoctorProfileLoaded(profile)),
    );
  }
}
