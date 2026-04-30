import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientProfileFlowCubit extends Cubit<PatientProfileFlowState> {
  PatientProfileFlowCubit() : super(const PatientProfileFlowState());

  void handlePrescriptionRouteResult(Object? result) {
    if (result == true) {
      emit(const PatientProfileFlowState(prescriptionCompleted: true));
    }
  }
}

class PatientProfileFlowState extends Equatable {
  final bool prescriptionCompleted;

  const PatientProfileFlowState({this.prescriptionCompleted = false});

  Object? get popResult => prescriptionCompleted ? true : null;

  @override
  List<Object?> get props => [prescriptionCompleted];
}
