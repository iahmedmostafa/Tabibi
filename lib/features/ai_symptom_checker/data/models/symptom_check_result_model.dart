import 'package:tabibi/features/ai_symptom_checker/domain/entities/symptom_check_result.dart';

class SymptomCheckResultModel extends SymptomCheckResult {
  const SymptomCheckResultModel({
    required super.answer,
  });

  factory SymptomCheckResultModel.fromJson(Map<String, dynamic> json) {
    return SymptomCheckResultModel(
      answer: json['answer'] ?? '',
    );
  }
}
