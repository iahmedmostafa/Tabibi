import 'package:equatable/equatable.dart';

class SymptomCheckResult extends Equatable {
  final String answer;

  const SymptomCheckResult({
    required this.answer,
  });

  @override
  List<Object?> get props => [
        answer,
      ];
}
