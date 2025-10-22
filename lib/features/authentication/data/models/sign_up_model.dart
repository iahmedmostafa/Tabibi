import 'package:tabibi/features/authentication/domain/entities/sign_up.dart';

class SignUpModel extends SignUp {
  const SignUpModel({
    required super.email,
    required super.password,
    required super.firstName,
    required super.lastName,
  });
  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
    );
  }
}
