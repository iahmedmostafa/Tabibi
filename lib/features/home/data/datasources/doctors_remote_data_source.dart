import 'package:dio/dio.dart';
import 'package:tabibi/core/network/api_constance.dart';

abstract class DoctorsRemoteDataSource {
  Future<List<Map<String, dynamic>>> getDoctors();
}

class DoctorsRemoteDataSourceImpl implements DoctorsRemoteDataSource {
  final Dio dio;

  DoctorsRemoteDataSourceImpl(this.dio) {
    dio.options.baseUrl = ApiConstance.baseUrl;
  }

  @override
  Future<List<Map<String, dynamic>>> getDoctors() async {
    try {
      final response = await dio.get(ApiConstance.doctors);
      final dynamic data = response.data;
      List<dynamic> items = [];

      if (data is List) {
        items = data;
      } else if (data is Map<String, dynamic>) {
        if (data.containsKey('items') && data['items'] is List) {
          items = data['items'];
        }
      }

      return items
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Server error');
    }
  }
}
