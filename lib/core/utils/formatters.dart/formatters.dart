import 'package:intl/intl.dart';

class Formatter {
  static String formatDateAndTime(
    DateTime? date, {
    bool use24HourFormat = false,
  }) {
    date ??= DateTime.now();
    final onlyDate = DateFormat('dd/MM/yyyy').format(date);
    // Use 'hh:mm a' for 12-hour with AM/PM, or 'HH:mm' for 24-hour format.
    final timeFormat = use24HourFormat ? 'HH:mm' : 'hh:mm a';
    final onlyTime = DateFormat(timeFormat).format(date);
    return '$onlyDate at $onlyTime';
  }

  static String formatIsoTo12Hour(String isoDate) {
    final dateTime = DateTime.parse(isoDate).toLocal();
    return DateFormat('hh:mm a').format(dateTime);
  }
  static String formatTo12Hour(String time24) {
  final dateTime = DateFormat('HH:mm').parse(time24);
  return DateFormat('hh:mm a').format(dateTime);
}

  static String formatIsoToDateTime(String isoDate) {
    final dateTime = DateTime.parse(isoDate).toLocal();
    return DateFormat('MMM dd, yyyy - hh.mm a').format(dateTime);
  }

  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat(
      'dd-MMM-yyyy',
    ).format(date); // Customize the date format as needed
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
    ).format(amount); // Customize the currency locale and symbol as needed
  }
}
