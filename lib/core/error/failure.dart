import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/network/error_message_model.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
  
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}
void handleDioException(Object e) {
  if (e is DioException) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        throw ServerException(errorMessageModel: ErrorMessageModel(
          statusCode: e.response?.statusCode ?? 408,
          statusMessage: "Connection Timeout",
        ));
      case DioExceptionType.sendTimeout:
        throw ServerException(errorMessageModel: ErrorMessageModel(
          statusCode: e.response?.statusCode ?? 408,
          statusMessage: "Send Timeout",
        ));
      case DioExceptionType.receiveTimeout:
        throw ServerException(errorMessageModel: ErrorMessageModel(
          statusCode: e.response?.statusCode ?? 408,
          statusMessage: "Receive Timeout",
        ));
      case DioExceptionType.badResponse:
        if (e.response != null && e.response?.data != null) {
          throw ServerException(errorMessageModel: ErrorMessageModel.fromJson(e.response?.data));  
        } else {
          throw ServerException(errorMessageModel: ErrorMessageModel(
            statusCode: e.response?.statusCode ?? 500,
            statusMessage: "Received invalid status code: ${e.response?.statusCode}",
          ));

        }
      case DioExceptionType.cancel:
        throw ServerException(errorMessageModel: ErrorMessageModel(
          statusCode: e.response?.statusCode ?? 499,
          statusMessage: "Request to API server was cancelled",
        ));
      case DioExceptionType.connectionError:
        throw ServerException(errorMessageModel: ErrorMessageModel(
          statusCode: e.response?.statusCode ?? 503,
          statusMessage: "Connection to API server failed due to internet connection",
        ));
      case DioExceptionType.unknown:
        throw ServerException(errorMessageModel: ErrorMessageModel(
          statusCode: e.response?.statusCode ?? 520,
          statusMessage: "Unknown error occurred",
        ));
      case DioExceptionType.badCertificate:
        throw ServerException(errorMessageModel: ErrorMessageModel(
          statusCode: e.response?.statusCode ?? 526,
          statusMessage: "Bad certificate",
        ));
    
    }
  }
}