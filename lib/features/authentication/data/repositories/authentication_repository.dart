import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/exceptions.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/authentication/data/datasources/auth_remote_date_source.dart';
import 'package:tabibi/features/authentication/domain/repositories/base_authentication_repository.dart';
import 'package:tabibi/features/authentication/domain/usecases/sign_up_use_case.dart';

class AuthenticationRepository extends BaseAuthenticationRepository {
  BaseAuthenticationRemoteDataSource baseAuthenticationRemoteDataSource;
  AuthenticationRepository(this.baseAuthenticationRemoteDataSource);
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
}
