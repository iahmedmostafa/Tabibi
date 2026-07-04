import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/features/doctor/appointments/domain/usecases/get_appointment_details_usecase.dart';
import 'package:tabibi/features/doctor/appointments/presentation/cubit/appointment_details_state.dart';
import 'package:easy_localization/easy_localization.dart';

class AppointmentDetailsCubit extends Cubit<AppointmentDetailsState> {
  final GetAppointmentDetailsUseCase getAppointmentDetailsUseCase;

  AppointmentDetailsCubit(this.getAppointmentDetailsUseCase)
    : super(AppointmentDetailsInitial());

  Future<void> getAppointmentDetails(String id) async {
    emit(AppointmentDetailsLoading());
    try {
      final details = await getAppointmentDetailsUseCase.call(id);
      emit(AppointmentDetailsLoaded(details));
    } on ServerException catch (e) {
      emit(AppointmentDetailsError(e.errorMessageModel.statusMessage));
    } catch (e) {
      emit(AppointmentDetailsError('failedToFetchAppointmentDetails'.tr()));
    }
  }

  Future<void> handlePatientProfileRouteResult({
    required String appointmentId,
    required Object? result,
  }) async {
    if (result == true) {
      await getAppointmentDetails(appointmentId);
    }
  }
}
