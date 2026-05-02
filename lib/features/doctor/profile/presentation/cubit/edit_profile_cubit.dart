import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/doctor/profile/data/models/update_doctor_profile_request.dart';
import 'package:tabibi/features/doctor/profile/domain/repositories/doctor_profile_repository.dart';
import 'package:tabibi/features/doctor/profile/presentation/cubit/edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final DoctorProfileRepository repository;

  EditProfileCubit(this.repository) : super(EditProfileInitial());

  Future<void> updateProfile(UpdateDoctorProfileRequest request) async {
    emit(EditProfileLoading());
    final result = await repository.updateDoctorProfile(request);
    result.fold(
      (failure) => emit(EditProfileError(failure.message)),
      (_) => emit(EditProfileSuccess()),
    );
  }
}
