import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/ai_symptom_checker/domain/entities/symptom_check_result.dart';
import 'package:tabibi/features/ai_symptom_checker/domain/repositories/base_ai_repository.dart';

class CheckSymptomsUseCase {
  final BaseAiRepository repository;

  CheckSymptomsUseCase(this.repository);

  Future<Either<Failure, SymptomCheckResult>> execute(String symptomsText) {
    return repository.checkSymptoms(symptomsText);
  }
}
