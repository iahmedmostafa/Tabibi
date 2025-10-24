import 'package:dio/dio.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/network/error_message_model.dart';
import 'package:tabibi/features/authentication/domain/usecases/create_new_password_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/forgot_password_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/sign_up_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/verify_code_use_case.dart';

abstract class BaseAuthenticationRemoteDataSource {

  Future<String> signup(SignUpParameters parameters);
  Future<String> forgotPassword(ForgotPasswordParameters parameters);
  Future<String> verifyCode(VerifyCodeParameters parameters);
  Future<String> createNewPassword(CreateNewPasswordParameters parameters);
}

class AuthenticationRemoteDataSource
    extends BaseAuthenticationRemoteDataSource {
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
      handleDioException(e);
      rethrow;
    }
  }

  @override
  Future<String> forgotPassword(ForgotPasswordParameters parameters) async {
    await Future.delayed(const Duration(seconds: 2));

    final registeredEmails = ['test@example.com', 'abdo@gmail.com'];

    if (!registeredEmails.contains(parameters.email)) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel(
          statusCode: 404,
          statusMessage: 'This email is not registered',
        ),
      );
    }

    return 'Verification code sent successfully to ${parameters.email}';
  }

  /*@override
  Future<String> forgotPassword(ForgotPasswordParameters parameters) async {
    try {
      final response = await dio.post(
        '/api/auth/forget-password',
        data: {'email': parameters.email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['message'];
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(response.data),
        );
      }
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }*/

  @override
  Future<String> verifyCode(VerifyCodeParameters parameters) async {
    try {
      final response = await dio.post(
        '${ApiConstance.baseUrl}/api/auth/verify-code',
        data: {
          ApiKeys.email: parameters.email,
          ApiKeys.code: parameters.code,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['message'] ?? 'Code verified successfully';
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

  @override
  Future<String> createNewPassword(CreateNewPasswordParameters parameters) async {
    try {
      final response = await dio.post(
        '${ApiConstance.baseUrl}/api/auth/reset-password',
        data: {
          ApiKeys.email: parameters.email,
          ApiKeys.password: parameters.newPassword,
          ApiKeys.confirmPassword: parameters.confirmPassword,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['message'] ?? 'Password reset successfully';
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

