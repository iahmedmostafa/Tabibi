import 'package:dio/dio.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/features/home/data/models/doctors_filter_params.dart';
import '../models/doctors_response_model.dart';

abstract class DoctorsRemoteDataSource {
  /// Fetches doctors from the API with pagination and optional filters
  Future<DoctorsResponseModel> getDoctors({
    int page = 1,
    int pageSize = 10,
    String? departmentId,
    String? query,
    int? gender,
    String? cityId,
    String? sort,
    String? fields,
    DoctorsFilterParams? filters,
  });
}

class DoctorsRemoteDataSourceImpl implements DoctorsRemoteDataSource {
  final Dio dio;

  DoctorsRemoteDataSourceImpl(this.dio);

  @override
  Future<DoctorsResponseModel> getDoctors({
    int page = 1,
    int pageSize = 10,
    String? departmentId,
    String? query,
    int? gender,
    String? cityId,
    String? sort,
    String? fields,
    DoctorsFilterParams? filters,
  }) async {
    try {
      final activeFilters =
          filters ??
          DoctorsFilterParams(
            query: query,
            gender: gender,
            cityId: cityId,
            departmentId: departmentId,
            sort: sort,
            fields: fields,
            pageSize: pageSize,
          );

      final response = await dio.get(
        ApiConstance.doctors,
        queryParameters: activeFilters.toQueryParameters(page: page),
      );

      return DoctorsResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Server error');
    }
  }
}
