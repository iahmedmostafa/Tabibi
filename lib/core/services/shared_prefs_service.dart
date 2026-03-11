import 'package:shared_preferences/shared_preferences.dart';

class OnboardingServices {
  static late SharedPreferences _sharedPref;

  static Future<void> init() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  static bool isFirstTime() {
    return _sharedPref.getBool('first_time') ?? true;
  }

  static Future<void> setSeen() async {
    await _sharedPref.setBool('first_time', false);
  }

  static bool isLoggedIn() {
    return _sharedPref.getBool('is_logged_in') ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    await _sharedPref.setBool('is_logged_in', value);
  }

  static String? getRole() {
    return _sharedPref.getString('user_role');
  }

  static Future<void> setRole(String role) async {
    await _sharedPref.setString('user_role', role);
  }

  static bool isProfileFilled() {
    return _sharedPref.getBool('is_profile_filled') ?? false;
  }

  static Future<void> setProfileFilled(bool value) async {
    await _sharedPref.setBool('is_profile_filled', value);
  }
}
