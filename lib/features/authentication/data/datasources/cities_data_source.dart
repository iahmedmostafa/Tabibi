import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/dio_interceptors.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/authentication/data/models/city_model.dart';

class CitiesDataSource {
  final Dio dio;

  CitiesDataSource(this.dio) {
    dio.options.baseUrl = ApiConstance.baseUrl;
    dio.interceptors.add(DioInterceptors(dio).interceptor);
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);
  }

  Future<List<CityModel>> getCities() async {
    try {
      final response = await dio.get(ApiConstance.cities);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> citiesJson = response.data as List<dynamic>;
        return citiesJson.map((json) => CityModel.fromJson(json)).toList();
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
