import 'package:equatable/equatable.dart';

class CreateNewPassword extends Equatable {
  final String email;
  final String newPassword;
  final String confirmPassword;

  const CreateNewPassword({
    required this.email,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, newPassword, confirmPassword];
}