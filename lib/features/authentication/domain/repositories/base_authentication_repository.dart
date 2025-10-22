import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/authentication/data/models/log_in_request_params_model.dart';
import 'package:tabibi/features/authentication/domain/entities/log_in_entity.dart';
import 'package:tabibi/features/authentication/domain/usecases/sign_up_use_case.dart';

abstract class BaseAuthenticationRepository {
  Future<Either<Failure, String>> signup(SignUpParameters parameters);

  Future<Either<Failure, LogInEntity>> logIn(LogInRequestParamsModel parameters);
}
