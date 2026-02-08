import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/services/cache_helper.dart';

class DioInterceptors {
  final Dio dio;
  DioInterceptors(this.dio);
  InterceptorsWrapper get interceptor => InterceptorsWrapper(
    onRequest: (options, handler) async {
      final accessToken = await CacheHelper.getData(key: ApiKeys.accessToken);
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
        log("📤 Sending request with token: Bearer $accessToken");
      }
      return handler.next(options); //continue
    },

    onError: (DioException e, handler) async {
      if (e.response?.statusCode == 401) {
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          // 🟡 لو التجديد نجح → عيد الطلب بنفس الـ Access Token الجديد
          final newToken = await CacheHelper.getData(key: ApiKeys.accessToken);
          final requestOptions = e.requestOptions;
          requestOptions.headers["Authorization"] = "Bearer $newToken";

          final response = await dio.fetch(requestOptions);
          return handler.resolve(response);
        }
      }
      return handler.next(e);
    },
  );

  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await CacheHelper.getData(key: ApiKeys.refreshToken);
      if (refreshToken == null) return false;

      // 🔴 حسب الـ Docs الـ Content-Type لازم يكون application/json-patch+json
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiConstance.baseUrl,
          headers: {'Content-Type': 'application/json-patch+json'},
        ),
      );

      // 📝 لازم نحول الـ Map لـ String يدوياً عشان الـ Content-Type مش standard json
      final response = await refreshDio.post(
        ApiConstance.generateNewAccessToken,
        data: jsonEncode({ApiKeys.refreshToken: refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final newAccessToken = data[ApiKeys.accessToken];
        final newRefreshToken = data[ApiKeys.refreshToken];

        if (newAccessToken != null) {
          await CacheHelper.saveData(
            key: ApiKeys.accessToken,
            value: newAccessToken,
          );
          if (newRefreshToken != null) {
            await CacheHelper.saveData(
              key: ApiKeys.refreshToken,
              value: newRefreshToken,
            );
          }

          log("✅ Token refreshed successfully");
          return true;
        }
      }
      return false;
    } catch (e) {
      log("❌ Refresh failed: $e");
      return false;
    }
  }
}
