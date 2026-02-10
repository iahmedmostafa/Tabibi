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

      // final refreshDio = Dio(
      //   BaseOptions(
      //     headers: {'Content-Type': 'application/json-patch+json'},
      //   ),
      // );

      final response = await dio.post(
        ApiConstance.generateNewAccessToken,
        data: jsonEncode({ApiKeys.refreshToken: refreshToken}),
        options: Options(
          headers: {'Content-Type': 'application/json-patch+json'},
        ),
      );

      if (response.statusCode == 200) {
        final dynamic respData = response.data;
        final Map<String, dynamic> data = respData is String
            ? jsonDecode(respData)
            : respData;

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
      if (e is DioException) {
        log(
          "❌ Refresh failed: ${e.response?.statusCode} - ${e.response?.data}",
        );
      } else {
        log("❌ Refresh failed: $e");
      }
      return false;
    }
  }
}
