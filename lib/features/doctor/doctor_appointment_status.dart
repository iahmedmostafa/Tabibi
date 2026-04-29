class DoctorAppointmentStatus {
  const DoctorAppointmentStatus._();

  static const int upcoming = 1;
  static const int completed = 2;
  static const int refunded = 4;

  static int fromJson(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? upcoming;
    return upcoming;
  }

  static bool isUpcoming(int status) => status == upcoming;
  static bool isCompleted(int status) => status == completed;
  static bool isRefunded(int status) => status == refunded;

  static String label(int status) {
    switch (status) {
      case upcoming:
        return 'Upcoming';
      case completed:
        return 'Completed';
      case refunded:
        return 'Refunded';
      default:
        return 'Unknown';
    }
  }
}
