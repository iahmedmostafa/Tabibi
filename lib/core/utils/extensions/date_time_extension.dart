import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/utils/helper/backend_date_time.dart';

extension DateTimeParsing on String {
  static final RegExp _backendSlashDateRegex = RegExp(
    r'\b\d{1,2}\/\d{1,2}\/\d{4}\s+\d{1,2}:\d{2}\s*(?:AM|PM|am|pm)\b',
  );

  /// Converts ISO 8601 UTC strings from backend to Local time for display.
  /// Backend sends true UTC; .toLocal() converts to device timezone.
  /// Handles both raw ISO dates ("2024-03-06T11:30:00Z") and text ("Time: 11:30 AM").
  String toLocalTimeStrings() {
    String result = this;

    // 1. Convert iso strings first if there are any (e.g. 2024-03-06T11:30:00Z)
    final isoRegex = RegExp(
      r'\b((\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?Z?)\b',
    );
    result = result.replaceAllMapped(isoRegex, (match) {
      try {
        final isoString = match.group(0)!;
        final date = BackendDateTime.parseUtc(isoString).toLocal();
        return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
      } catch (e) {
        return match.group(0)!;
      }
    });

    // 2. Normalize standalone time strings without changing timezone semantics.
    final timeRegex = RegExp(r'\b(\d{1,2}):(\d{2})\s*(AM|PM|am|pm)?\b');
    result = result.replaceAllMapped(timeRegex, (match) {
      try {
        final timeString = match.group(0)!;
        final is12Hour = match.group(3) != null;

        final formatStr = is12Hour ? 'h:mm a' : 'HH:mm';
        final format = DateFormat(formatStr);
        final parsedTime = format.parse(timeString.trim().toUpperCase());

        final now = DateTime.now();
        final localDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          parsedTime.hour,
          parsedTime.minute,
        );

        return format.format(localDateTime);
      } catch (e) {
        return match.group(0)!;
      }
    });

    return result;
  }

  String formatNotificationMessageTime() {
    return replaceAllMapped(_backendSlashDateRegex, (match) {
      try {
        final utcDateTime = BackendDateTime.parseBackendUsDateUtc(
          match.group(0)!,
        );
        return DateFormat('M/d/yyyy h:mm a').format(utcDateTime.toLocal());
      } catch (_) {
        return match.group(0)!;
      }
    });
  }

  String formatVideoCallErrorMessage(BuildContext context) {
    final message = this;
    final RegExp backendTimeRegex = RegExp(
      r'\bTime:\s*(\d{1,2}:\d{2}\s*(?:AM|PM|am|pm))\b',
    );
    return message.replaceAllMapped(backendTimeRegex, (match) {
      final rawTime = match.group(1);
      if (rawTime == null) return match.group(0)!;

      try {
        final nowUtc = DateTime.now().toUtc();
        final parsedTime = BackendDateTime.parseBackendUsDateUtc(
          '${nowUtc.month}/${nowUtc.day}/${nowUtc.year} $rawTime',
        );
        final localTime = MaterialLocalizations.of(
          context,
        ).formatTimeOfDay(TimeOfDay.fromDateTime(parsedTime.toLocal()));
        return 'Time: $localTime';
      } catch (_) {
        return match.group(0)!;
      }
    });
  }
}
