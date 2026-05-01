import 'package:intl/intl.dart';

class BackendDateTime {
  BackendDateTime._();

  static final RegExp _timezoneSuffixPattern = RegExp(r'(Z|[+-]\d{2}:\d{2})$');
  static final DateFormat _backendUsDateFormat = DateFormat(
    'M/d/yyyy h:mm a',
  );

  /// Parses backend timestamps as UTC even when the API omits the `Z` suffix.
  static DateTime parseUtc(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      throw FormatException('Invalid backend date: $value');
    }

    if (_timezoneSuffixPattern.hasMatch(value)) {
      return parsed.toUtc();
    }

    return DateTime.utc(
      parsed.year,
      parsed.month,
      parsed.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
      parsed.millisecond,
      parsed.microsecond,
    );
  }

  static DateTime? tryParseUtc(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    try {
      return parseUtc(value.trim());
    } catch (_) {
      return null;
    }
  }

  /// Parses backend-formatted US date strings as UTC, e.g. `4/28/2026 1:46 PM`.
  static DateTime parseBackendUsDateUtc(String value) {
    final parsed = _backendUsDateFormat.parseStrict(value);
    return DateTime.utc(
      parsed.year,
      parsed.month,
      parsed.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
      parsed.millisecond,
      parsed.microsecond,
    );
  }

  
  
}
