import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/ai_symptom_checker/domain/usecases/check_symptoms_use_case.dart';
import 'package:tabibi/features/ai_symptom_checker/presentation/cubit/ai_symptom_state.dart';

class AiSymptomCubit extends Cubit<AiSymptomState> {
  final CheckSymptomsUseCase _checkSymptomsUseCase;

  AiSymptomCubit(this._checkSymptomsUseCase) : super(AiSymptomInitial());

  Future<void> checkSymptoms(String symptomsText) async {
    emit(AiSymptomLoading());
    final result = await _checkSymptomsUseCase.execute(symptomsText);
    result.fold(
      (failure) => emit(AiSymptomFailure(failure.message)),
      (symptomCheckResult) => emit(AiSymptomSuccess(symptomCheckResult)),
    );
  }

  void reset() {
    emit(AiSymptomInitial());
  }
}
