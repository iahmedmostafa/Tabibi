import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class ApiConfig {
  ApiConfig._();

  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static const String _emulatorUrl = 'http://10.0.2.2:8000';
  static const String _deviceUrl = 'http://192.168.1.5:8000';
  static const String _localUrl = 'http://localhost:8000';

  static Future<String> getBaseUrl() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      if (!androidInfo.isPhysicalDevice) {
        return _emulatorUrl;
      }
      return _deviceUrl;
    }

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      if (!iosInfo.isPhysicalDevice) {
        return _localUrl;
      }
      return _deviceUrl;
    }

    return _localUrl;
  }
}
