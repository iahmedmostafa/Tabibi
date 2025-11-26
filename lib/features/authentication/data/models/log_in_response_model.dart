import '../../domain/entities/log_in_entity.dart';

class LogInResponseModel extends LogInEntity {


  const LogInResponseModel({
    required super.accessToken,
    required super.refreshToken,
  });
  factory LogInResponseModel.fromJson(Map<String, dynamic> json) {
    return LogInResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
