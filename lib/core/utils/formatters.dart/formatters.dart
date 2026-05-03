import 'package:intl/intl.dart';
import 'package:tabibi/core/utils/helper/backend_date_time.dart';

class Formatter {
  static String getDayName(int day) {
    switch (day) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 0:
        return "Sunday";
      default:
        return "";
    }
  }

  /// Converts a UTC ISO 8601 date string to 12-hour LOCAL time for display.
  static String formatIsoTo12Hour(String isoDate) {
    if (isoDate.isEmpty) return "";
    try {
      final dateTime = BackendDateTime.parseUtc(isoDate).toLocal();
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return isoDate;
    }
  }

  /// Converts a 24-hour UTC time string from backend schedule to 12-hour local format.
  /// Example: "21:25:00" (UTC) → "12:25 AM" (UTC+3)
  static String formatTo12Hour(String time24) {
    if (time24.isEmpty) return "";
    try {
      final parts = time24.split(':');
      if (parts.length < 2) return time24;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // Backend stores schedule times in UTC — convert to local for display
      final now = DateTime.now();
      final utcDateTime = DateTime.utc(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
      final localDateTime = utcDateTime.toLocal();

      return DateFormat('hh:mm a').format(localDateTime);
    } catch (e) {
      return time24;
    }
  }

  /// Formats an appointment DateTime for doctor-facing UIs in local time.
  static String formatDateForDoctor(DateTime date) {
    return DateFormat('hh:mm a').format(date.toLocal());
  }

  /// Formats an appointment date for doctor-facing UIs in local time.
  static String formatTimeForDoctor(DateTime date) {
    return DateFormat('MMM dd').format(date.toLocal());
  }

  /// Converts a UTC ISO 8601 date string to local date+time for display.
  static String formatIsoToDateTime(String isoDate) {
    if (isoDate.isEmpty) return "";
    try {
      final dateTime = BackendDateTime.parseUtc(isoDate).toLocal();
      return DateFormat('MMM dd, yyyy - hh.mm a').format(dateTime);
    } catch (e) {
      return isoDate;
    }
  }
}
