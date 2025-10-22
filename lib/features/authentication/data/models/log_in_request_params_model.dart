import 'package:equatable/equatable.dart';

class LogInRequestParamsModel extends Equatable{
  final String email;
  final String password;

  const LogInRequestParamsModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
  factory LogInRequestParamsModel.fromJson(Map<String, dynamic> map) {
    return LogInRequestParamsModel(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  @override
  List<Object?> get props => [email,password];
}