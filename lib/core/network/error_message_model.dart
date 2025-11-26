class ErrorMessageModel {
  final int statusCode;
  final String statusMessage;
  final Map<String, List<String>>? errors;

  ErrorMessageModel({
    required this.statusCode,
    required this.statusMessage,
    this.errors,
  });

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>>? parsedErrors;
    if (json['errors'] != null) {
      parsedErrors = {};
      json['errors'].forEach((key, value) {
        if (value is List) {
          parsedErrors![key] = List<String>.from(
            value.map((e) => e.toString()),
          );
        } else if (value is String) {
          parsedErrors![key] = [value];
        } else {
          parsedErrors![key] = [value.toString()];
        }
      });
    }

    return ErrorMessageModel(
      statusCode: json['status'] ?? 400,
      statusMessage: _formatErrors(parsedErrors) ?? json['detail'],
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
