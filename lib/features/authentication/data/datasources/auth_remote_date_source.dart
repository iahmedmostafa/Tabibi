import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/authentication/data/models/log_in_request_params_model.dart';
import 'package:tabibi/features/authentication/data/models/log_in_response_model.dart';
import 'package:tabibi/features/authentication/domain/usecases/sign_up_use_case.dart';

abstract class BaseAuthenticationRemoteDataSource {
  Future<String> signup(SignUpParameters parameters);
  Future<LogInResponseModel> logIn(LogInRequestParamsModel parameters);
}

class AuthenticationRemoteDataSource extends BaseAuthenticationRemoteDataSource {
  final Dio dio;
  AuthenticationRemoteDataSource(this.dio) {
    dio.options.baseUrl = ApiConstance.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);
  }

  @override
  Future<String> signup(SignUpParameters parameters) async {
    try {
      final response = await dio.post(
        ApiConstance.signUp,
        data: {
          ApiKeys.email: parameters.email,
          ApiKeys.firstName: parameters.firstName,
          ApiKeys.lastName: parameters.lastName,
          ApiKeys.password: parameters.password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['message'];
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } on DioException catch (e) {
      // convert Dio errors to ServerException via central handler
      handleDioException(e);
      // handleDioException throws a ServerException, but Dart requires a return here
      // This line will never be reached because handleDioException always throws, but
      // we add a rethrow to satisfy static analysis.
      rethrow;
    }
  }

  @override
  Future<LogInResponseModel> logIn(LogInRequestParamsModel parameters) async {
    try {
      final response = await dio.post(
        ApiConstance.logIn,
        data: {
          ApiKeys.email: parameters.email,
          ApiKeys.password: parameters.password,
        },
      );
      if (response.statusCode == 200) {
        return LogInResponseModel.fromJson(response.data);
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
