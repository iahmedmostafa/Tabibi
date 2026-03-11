import 'package:intl/intl.dart';

extension DateTimeParsing on String {
  /// Converts ISO 8601 strings and embedded time formatted strings from UTC to Local time.
  /// Handles both raw ISO dates ("2024-03-06T11:30:00") and text ("Time: 11:30 AM").
  String toLocalTimeStrings() {
    String result = this;

    // 1. Convert iso strings first if there are any (e.g. 2024-03-06T11:30:00Z)
    final isoRegex = RegExp(
      r'\b((\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?Z?)\b',
    );
    result = result.replaceAllMapped(isoRegex, (match) {
      try {
        final isoString = match.group(0)!;
        final date = DateTime.parse(
          isoString.endsWith('Z') ? isoString : '${isoString}Z',
        ).toLocal();
        return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
      } catch (e) {
        return match.group(0)!;
      }
    });

    // 2. Convert standard 12-hour or 24-hour time patterns (e.g., "11:30 AM", "14:30")
    final timeRegex = RegExp(r'\b(\d{1,2}):(\d{2})\s*(AM|PM|am|pm)?\b');
    result = result.replaceAllMapped(timeRegex, (match) {
      try {
        final timeString = match.group(0)!;
        final is12Hour = match.group(3) != null;

        final formatStr = is12Hour ? 'h:mm a' : 'HH:mm';
        final format = DateFormat(formatStr);
        final parsedTime = format.parse(timeString.trim().toUpperCase());

        // Assume the time belongs to today's UTC context
        final nowUtc = DateTime.now().toUtc();
        final utcDateTime = DateTime.utc(
          nowUtc.year,
          nowUtc.month,
          nowUtc.day,
          parsedTime.hour,
          parsedTime.minute,
        );

        final localDateTime = utcDateTime.toLocal();
        return format.format(localDateTime);
      } catch (e) {
        return match.group(0)!;
      }
    });

    return result;
  }
}
