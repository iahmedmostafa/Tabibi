import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/doctor_details/domain/usecases/get_doctor_details_use_case.dart';
import 'package:tabibi/features/doctor_details/presentation/controller/doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final GetDoctorDetailsUseCase getDoctorDetailsUseCase;

  DoctorDetailsCubit(this.getDoctorDetailsUseCase)
    : super(DoctorDetailsInitial());

  Future<void> getDoctorDetails(String id) async {
    emit(DoctorDetailsLoading());

    final result = await getDoctorDetailsUseCase.execute(id);

    result.fold(
      (failure) => emit(DoctorDetailsFailure(failure.message)),
      (doctorDetails) => emit(DoctorDetailsSuccess(doctorDetails)),
    );
  }
}
