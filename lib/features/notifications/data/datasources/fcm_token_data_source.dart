import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';

abstract class FcmTokenDataSource {
  Future<void> registerToken(String fcmToken);
}

class FcmTokenDataSourceImpl implements FcmTokenDataSource {
  final Dio dio;

  FcmTokenDataSourceImpl({required this.dio});

  @override
  Future<void> registerToken(String fcmToken) async {
    try {
      await dio.put(
        ApiConstance.fcmToken,
        data: {'fcmToken': fcmToken},
        options: Options(contentType: 'application/json-patch+json'),
      );
      log('📱 FCM token registered with backend ✅');
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      log('📱 FCM token registration failed: $e');
      rethrow;
    }
  }
}
