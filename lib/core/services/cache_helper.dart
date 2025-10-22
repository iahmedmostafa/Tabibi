import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheHelper {
  static final storage =const FlutterSecureStorage();

  static Future<void> saveData({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  static Future<String?> getData({required String key}) async {
    return await storage.read(key: key);
  }

  static Future<void> deleteData({required String key}) async {
    await storage.delete(key: key);
  }
}
