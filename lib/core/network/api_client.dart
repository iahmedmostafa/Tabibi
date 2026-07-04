import 'package:dio/dio.dart';
import 'package:tabibi/core/network/api_config.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient._();

  static final ApiClient _instance = ApiClient._();
  factory ApiClient() => _instance;

  Future<void> init() async {
    final baseUrl = await ApiConfig.getBaseUrl();

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return _dio.get(path, queryParameters: queryParams);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return _dio.delete(path);
  }
}
