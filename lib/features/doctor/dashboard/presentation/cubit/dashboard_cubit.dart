import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/doctor/dashboard/domain/usecases/get_doctor_dashboard_use_case.dart';
import 'package:tabibi/features/doctor/dashboard/presentation/cubit/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDoctorDashboardUseCase getDoctorDashboardUseCase;

  DashboardCubit(this.getDoctorDashboardUseCase) : super(DashboardInitial());

  Future<void> getDoctorDashboard() async {
    emit(DashboardLoading());
    final result = await getDoctorDashboardUseCase(const NoParameters());
    result.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (data) => emit(DashboardLoaded(dashboardData: data)),
    );
  }
}
