import 'package:tabibi/core/utils/extensions/date_time_extension.dart';

class ErrorMessageModel {
  final int statusCode;
  final String statusMessage;
  final Map<String, List<String>>? errors;

  ErrorMessageModel({
    required this.statusCode,
    required String statusMessage,
    this.errors,
  }) : statusMessage = statusMessage.toLocalTimeStrings();

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>>? parsedErrors;
    if (json['errors'] != null) {
      parsedErrors = {};
      json['errors'].forEach((key, value) {
        if (value is List) {
          parsedErrors![key] = List<String>.from(
            value.map((e) => e.toString().toLocalTimeStrings()),
          );
        } else if (value is String) {
          parsedErrors![key] = [value.toLocalTimeStrings()];
        } else {
          parsedErrors![key] = [value.toString().toLocalTimeStrings()];
        }
      });
    }

    return ErrorMessageModel(
      statusCode: json['status'] ?? 400,
      statusMessage:
          (_formatErrors(parsedErrors) ??
          json['detail']?.toString() ??
          'Error'),
      errors: parsedErrors,
    );
  }

  static String? _formatErrors(Map<String, List<String>>? errors) {
    if (errors == null || errors.isEmpty) return null;
    final buffer = StringBuffer();
    errors.forEach((field, messages) {
      buffer.writeln('• $field:');
      for (var msg in messages) {
        buffer.writeln('   - $msg');
      }
    });
    return buffer.toString();
  }

  String get formattedErrors => _formatErrors(errors) ?? statusMessage;
}
