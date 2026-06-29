import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/ai_symptom_checker/domain/entities/symptom_check_result.dart';

abstract class BaseAiRepository {
  Future<Either<Failure, SymptomCheckResult>> checkSymptoms(String symptomsText);
}
