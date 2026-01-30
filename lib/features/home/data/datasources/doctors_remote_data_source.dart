import 'package:dio/dio.dart';
import 'package:tabibi/core/network/api_constance.dart';
import '../models/doctors_response_model.dart';

abstract class DoctorsRemoteDataSource {
  /// Fetches doctors from the API with pagination and optional filters
  Future<DoctorsResponseModel> getDoctors({
    int page = 1,
    int pageSize = 10,
    String? departmentId,
    String? query,
  });
}

class DoctorsRemoteDataSourceImpl implements DoctorsRemoteDataSource {
  final Dio dio;

  DoctorsRemoteDataSourceImpl(this.dio) {
    dio.options.baseUrl = ApiConstance.baseUrl;
  }

  @override
  Future<DoctorsResponseModel> getDoctors({
    int page = 1,
    int pageSize = 10,
    String? departmentId,
    String? query,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'Page': page,
        'PageSize': pageSize,
      };

      if (departmentId != null) {
        queryParams['DepartmentId'] = departmentId;
      }
      if (query != null && query.isNotEmpty) {
        queryParams['q'] = query;
      }

      final response = await dio.get(
        ApiConstance.doctors,
        queryParameters: queryParams,
      );

      return DoctorsResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Server error');
    }
  }
}
