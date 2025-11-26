class ApiConstance {
  ApiConstance._();
  static const String baseUrl = "https://tabibi.runasp.net/";
  static const String signUp = "auth/register";
  static const String login = "auth/login";
  static const String forgotPassword = "auth/forgot-password";
  static const String verifyCode = "auth/email-confirmation";
  static const String resetPassword = "auth/reset-password";
  static const String verifyPasswordResetCode = "auth/verify-password-reset-code";


  //  static const String refreshToken = "auth/refresh​";
  // static const String logout = "auth/logout";
  //  static const String activeCode = "auth/activate";
  static const String generateNewAccessToken = "auth/refresh";
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
}
