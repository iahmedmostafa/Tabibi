import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/authentication/domain/usecases/sign_up_use_case.dart';

abstract class BaseAuthenticationRemoteDataSource {
  Future<String> signup(SignUpParameters parameters);
}

class AuthenticationRemoteDataSource
    extends BaseAuthenticationRemoteDataSource {
  final Dio dio;
  AuthenticationRemoteDataSource(this.dio) {
    dio.options.baseUrl = ApiConstance.baseUrl;
  }

  @override
  Future<String> signup(SignUpParameters parameters) async {
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
  }
}
