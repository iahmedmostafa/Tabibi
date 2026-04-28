import 'package:intl/intl.dart';
import 'package:tabibi/core/utils/backend_date_time.dart';

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
  /// Converts to device timezone for user-friendly display.
  static String formatIsoTo12Hour(String isoDate) {
    if (isoDate.isEmpty) return "";
    try {
      final dateTime = BackendDateTime.parseUtc(isoDate).toLocal();
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return isoDate;
    }
  }

  /// Converts a 24-hour time string (e.g., from backend schedule) to 12-hour format.
  /// Example: "14:25:00" → "02:25 PM"
  static String formatTo12Hour(String time24) {
    if (time24.isEmpty) return "";
    try {
      final parts = time24.split(':');
      if (parts.length < 2) return time24;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // Create a DateTime with today's date and the given time in LOCAL timezone
      final now = DateTime.now();
      final localDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      return DateFormat('hh:mm a').format(localDateTime);
    } catch (e) {
      return time24;
    }
  }

  /// Formats a DateTime (already local) to 12-hour time string.
  static String formatDateForDoctor(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// Formats a DateTime to "MMM dd" date string.
  static String formatTimeForDoctor(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }

  /// Converts a UTC ISO 8601 date string to local date+time for display.
  /// Converts to device timezone for user-friendly display.
  static String formatIsoToDateTime(String isoDate) {
    if (isoDate.isEmpty) return "";
    try {
      final dateTime = BackendDateTime.parseUtc(isoDate).toLocal();
      return DateFormat('MMM dd, yyyy - hh.mm a').format(dateTime);
    } catch (e) {
      return isoDate;
    }
  }

  // static String formatCurrency(double amount) {
  //   return NumberFormat.currency(
  //     locale: 'en_US',
  //     symbol: '\$',
  //   ).format(amount); // Customize the currency locale and symbol as needed
  // }
}
