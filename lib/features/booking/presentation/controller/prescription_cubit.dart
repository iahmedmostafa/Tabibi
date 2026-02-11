import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibi/features/booking/data/models/prescription_model.dart';
import 'package:tabibi/features/booking/domain/usecases/get_prescription_use_case.dart';

part 'prescription_state.dart';

class PrescriptionCubit extends Cubit<PrescriptionState> {
  final GetPrescriptionUseCase getPrescriptionUseCase;

  PrescriptionCubit(this.getPrescriptionUseCase)
    : super(const PrescriptionState());

  void getPrescription({required String bookingId}) async {
    emit(state.copyWith(status: PrescriptionStatus.loading));
    final result = await getPrescriptionUseCase(bookingId: bookingId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PrescriptionStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (prescription) => emit(
        state.copyWith(
          status: PrescriptionStatus.success,
          prescription: prescription,
        ),
      ),
    );
  }
}
