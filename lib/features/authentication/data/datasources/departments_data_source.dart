import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/authentication/data/models/department_model.dart';

class DepartmentsDataSource {
  final Dio dio;

  DepartmentsDataSource(this.dio);

  Future<List<DepartmentModel>> getDepartments() async {
    try {
      final response = await dio.get(ApiConstance.departments);

      if (response.statusCode == 200) {
        final List<dynamic> departmentsJson =
            response.data['items'] as List<dynamic>;
        return departmentsJson
            .map((json) => DepartmentModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }
}
