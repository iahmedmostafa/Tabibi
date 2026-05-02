import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;

class ApiConstance {
  ApiConstance._();
  static const String serverUrl = "https://tabibi.runasp.net/hub";
  static const String baseUrl = "https://tabibi.runasp.net/";
  static const String signUp = "auth/register";
  static const String login = "auth/login";
  static const String forgotPassword = "auth/forgot-password";
  static const String verifyCode = "auth/email-confirmation";
  static const String resetPassword = "auth/reset-password";
  static const String verifyPasswordResetCode =
      "auth/verify-password-reset-code";
  static const String uploadImage = "images/upload";
  static const String cities = "cities";
  static const String patientProfile = "patients/me";
  static const String updatePatientProfile = "patients/me";
  static const String updateDoctorProfile = "doctors/me";
  static const String doctorProfile = "doctors/profile";
  static const String doctorStatus = "doctors/me/status";
  static const String doctors = "doctors";
  static const String doctorsMap = "doctors/map";
  static const String departments = "departments";
  static const String doctorDetails = "doctors/doctor-details";
  static const String doctorHome = "doctor-system/home";
  static const String doctorSchedule = "doctor-system/schedule";
  static const String doctorAppointments = "doctor-system/appointments";
  static const String doctorEarningsSummary = "doctor-system/earnings/summary";
  static const String doctorEarningsAnalytics =
      "doctor-system/earnings/analytics";
  static const String doctorTransactions = "doctor-system/transactions";
  static const String availableSlots = "bookings/available-slots";
  static const String booking = "bookings";
  static const String mybooking = "bookings/my-bookings";
  static const String reviews = "reviews";
  static const String myReviews = "reviews/me";
  static const String doctorReviews = "reviews/doctor/";
  static const String notifications = "notifications";
  static String markNotificationAsRead(String id) => "notifications/$id/read";
  static const String markAllNotificationsAsRead = "notifications/read-all";
  static const String unreadNotificationCount = "notifications/unread-count";

  // Favorites
  static const String favorites = "favorites";
  static String removeFavorite(String doctorId) => "favorites/$doctorId";
  // Chat
  static const String conversations = "chat/conversations";
  static String chatMessages(String id) => "chat/messages/$id";
  static const String sendChatMessage = "chat/send";

  // Video Call
  static String videoToken(String bookingId) => "video/token/$bookingId";

  // FCM
  static const String fcmToken = "notifications/fcm-token";

  static const String generateNewAccessToken = "auth/refresh";

  static String confirmPayment(String id) => "bookings/$id/confirm-payment";
  static String cancelBooking(String id) => "bookings/$id/cancel";
  static String prescription(String bookingId) =>
      "bookings/$bookingId/prescription";
}

class ApiKeys {
  ApiKeys._();

  static const String email = "email";
  static const String name = "name";
  static const String userName = "username";
  static const String role = "role";

  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String password = "password";
  static const String confirmPassword = "confirmPassword";
  static const String image = "image";
  static const String phoneNumber = "phone";
  static const String code = "code";
  static const String accessToken = "accessToken";
  static const String refreshToken = "refreshToken";
  static const String resetToken = "token";
  static const String expiresAtUtc = "expiresAtUtc";
  //profile
  static const String file = "File";
  static const String imageUrl = "imageUrl";
  static const String clientSecret = "clientSecret";
  static const String bookingId = "bookingId";
  static String get publishableKey =>
      dot_env.dotenv.get('STRIPE_PUBLISHABLE_KEY');
}
