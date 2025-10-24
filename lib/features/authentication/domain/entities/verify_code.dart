import 'package:equatable/equatable.dart';

class VerifyCode extends Equatable {
  final String email;
  final String code;

  const VerifyCode({
    required this.email,
    required this.code,
  });

  @override
  List<Object?> get props => [email, code];
}