import 'package:shared_preferences/shared_preferences.dart';

class onboardingServices {
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
}
