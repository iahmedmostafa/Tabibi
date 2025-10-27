class ApiConstance {
  ApiConstance._();
  static const String baseUrl = "http://localhost:8080/api/";
  static const String signUp = "auth/register";
  static const String login = "auth/login";
  static const String forgotPassword = "auth/Forget_password";
  static const String verifyCode = "auth/Verify_code";
  static const String resetPassword = "auth/Reset_password";
  static const String refreshToken = "auth/refresh";
  static const String logout = "auth/logout";
  static const String activeCode = "auth/activate";

}

class ApiKeys {
  ApiKeys._();

  static const String email = "email";
  static const String name = "name";
  static const String userName = "username";

  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String password = "password";
  static const String confirmPassword = "confirmPassword";
  static const String image = "image";
  static const String phoneNumber = "phone";
  static const String code = "code";
  static const String accessToken = "access_token";
  static const String refreshToken = "refresh_token";
  
}
