// lib/features/authentication/data/models/verify_code_model.dart

import 'package:tabibi/features/authentication/domain/entities/verify_code.dart'; // import the base Entity

class VerifyCodeModel extends VerifyCode {
  // استخدام super() لتمرير الخصائص إلى الـ Entity
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