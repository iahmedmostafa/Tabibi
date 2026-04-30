import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/doctor/schedule/domain/usecases/get_doctor_schedule_use_case.dart';
import 'package:tabibi/features/doctor/schedule/presentation/cubit/schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final GetDoctorScheduleUseCase getDoctorScheduleUseCase;

  ScheduleCubit(this.getDoctorScheduleUseCase) : super(ScheduleInitial());

  Future<void> getDoctorSchedule(String date) async {
    emit(ScheduleLoading());
    final result = await getDoctorScheduleUseCase(date);
    result.fold(
      (failure) => emit(ScheduleError(message: failure.message)),
      (data) => emit(ScheduleLoaded(appointments: data)),
    );
  }
}
