import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/routing/app_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/services/cache_helper.dart';
import 'package:tabibi/core/services/shared_prefs_service.dart';

class DioInterceptors {
  final Dio dio;
  DioInterceptors(this.dio);

  // 🔒 Lock to prevent multiple concurrent refresh attempts
  // When the first 401 triggers a refresh, all other 401s wait for the same result.
  Completer<bool>? _refreshCompleter;

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
        bool refreshed;

        if (_refreshCompleter != null) {
          // Another request is already refreshing → wait for it
          log("🔄 Waiting for ongoing token refresh...");
          refreshed = await _refreshCompleter!.future;
        } else {
          // First 401 → start the refresh
          _refreshCompleter = Completer<bool>();
          try {
            refreshed = await _refreshAccessToken();
            _refreshCompleter!.complete(refreshed);
          } catch (error) {
            _refreshCompleter!.complete(false);
            refreshed = false;
          } finally {
            _refreshCompleter = null;
          }
        }

        if (refreshed) {
          // Retry the original request with the new token
          final newToken = await CacheHelper.getData(key: ApiKeys.accessToken);
          final requestOptions = e.requestOptions;
          requestOptions.headers["Authorization"] = "Bearer $newToken";

          try {
            final response = await dio.fetch(requestOptions);
            return handler.resolve(response);
          } on DioException catch (retryError) {
            return handler.next(retryError);
          }
        }
      }
      return handler.next(e);
    },
  );

  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await CacheHelper.getData(key: ApiKeys.refreshToken);
      if (refreshToken == null) return false;

      // ⚠️ Use a SEPARATE Dio instance so the refresh request
      // does NOT go through this interceptor (avoids recursion)
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiConstance.baseUrl,
          headers: {'Content-Type': 'application/json-patch+json'},
        ),
      );

      final response = await refreshDio.post(
        ApiConstance.generateNewAccessToken,
        data: jsonEncode({ApiKeys.refreshToken: refreshToken}),
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
        // If refresh token is truly expired (after 7 days), force logout
        if (e.response?.statusCode == 400) {
          await _forceLogout();
        }
      } else {
        log("❌ Refresh failed: $e");
      }
      return false;
    }
  }

  Future<void> _forceLogout() async {
    log("🔒 Force logout: clearing tokens and redirecting to login");
    await CacheHelper.clearAuthSession();
    await OnboardingServices.clearSession();

    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      GoRouter.of(context).go(AppRoutes.login);
    }
  }
}
