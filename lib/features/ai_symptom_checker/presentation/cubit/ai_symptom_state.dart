import 'package:equatable/equatable.dart';
import 'package:tabibi/features/ai_symptom_checker/domain/entities/symptom_check_result.dart';

abstract class AiSymptomState extends Equatable {
  const AiSymptomState();

  @override
  List<Object?> get props => [];
}

class AiSymptomInitial extends AiSymptomState {}

class AiSymptomLoading extends AiSymptomState {}

class AiSymptomSuccess extends AiSymptomState {
  final SymptomCheckResult result;

  const AiSymptomSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class AiSymptomFailure extends AiSymptomState {
  final String message;

  const AiSymptomFailure(this.message);

  @override
  List<Object?> get props => [message];
}
