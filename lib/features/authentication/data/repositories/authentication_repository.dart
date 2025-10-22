import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/network/api_constance.dart';
import 'package:tabibi/core/services/cache_helper.dart';
import 'package:tabibi/features/authentication/data/datasources/auth_remote_date_source.dart';
import 'package:tabibi/features/authentication/data/models/log_in_request_params_model.dart';
import 'package:tabibi/features/authentication/domain/entities/log_in_entity.dart';
import 'package:tabibi/features/authentication/domain/repositories/base_authentication_repository.dart';
import 'package:tabibi/features/authentication/domain/usecases/sign_up_use_case.dart';

class AuthenticationRepositoryImpl extends BaseAuthenticationRepository {

  BaseAuthenticationRemoteDataSource baseAuthenticationRemoteDataSource;
  AuthenticationRepositoryImpl(this.baseAuthenticationRemoteDataSource);

  @override
  Future<Either<Failure, String>> signup(SignUpParameters parameters) async {
    try {
      final String response = await baseAuthenticationRemoteDataSource.signup(
        parameters,
      );
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LogInEntity>> logIn(LogInRequestParamsModel parameters)async {
    try {
      final LogInEntity response = await baseAuthenticationRemoteDataSource.logIn(parameters);
      await CacheHelper.saveData(key: ApiKeys.accessToken, value: response.accessToken);
      await CacheHelper.saveData(key: ApiKeys.refreshToken, value: response.refreshToken);
     // log(" Access Token is :${await CacheHelper.getData(key: ApiKeys.accessToken)}");

      return Right(response);

    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
