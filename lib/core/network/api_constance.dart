import 'package:http/http.dart' as dotenv;

class ApiConstance {
  ApiConstance._();
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
  static const String doctorStatus = "doctors/me/status";
  static const String doctors = "doctors";
  static const String doctorsMap = "doctors/map";
  static const String departments = "departments";
  static const String doctorDetails = "doctors/doctor-details";
  static const String availableSlots = "bookings/available-slots";
  static const String booking = "bookings";

  //  static const String refreshToken = "auth/refresh";
  // static const String logout = "auth/logout";
  //  static const String activeCode = "auth/activate";
  static const String generateNewAccessToken = "auth/refresh";

  static String confirmPayment(String id) => "bookings/$id/confirm-payment";
  static String cancelBooking(String id) => "bookings/$id/cancel";
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
  static String get publishableKey => dotenv.get('STRIPE_PUBLISHABLE_KEY');
}
