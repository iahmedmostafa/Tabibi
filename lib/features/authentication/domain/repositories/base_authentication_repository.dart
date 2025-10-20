import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/authentication/domain/usecases/forgot_password_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/sign_up_use_case.dart';

abstract class BaseAuthenticationRepository {
  Future<Either<Failure,String>> signup(
    SignUpParameters parameters
  );
  Future<Either<Failure, String>> forgotPassword(ForgotPasswordParameters parameters);
}