import 'package:tabibi/features/authentication/domain/entities/verify_code.dart'; // import the base Entity

class VerifyCodeModel extends VerifyCode {
  const VerifyCodeModel({
    required super.email,
    required super.code,
  });
  factory VerifyCodeModel.fromJson(Map<String, dynamic> json) {
    return VerifyCodeModel(
      email: json['email'],
      code: json['code'],
    );
  }
}