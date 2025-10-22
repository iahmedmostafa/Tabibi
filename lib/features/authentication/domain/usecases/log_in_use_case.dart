import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/authentication/data/models/log_in_request_params_model.dart';
import 'package:tabibi/features/authentication/domain/entities/log_in_entity.dart';

import '../repositories/base_authentication_repository.dart';

class LogInUseCase{
  final BaseAuthenticationRepository loginRepository;
  LogInUseCase(this.loginRepository);

  Future<Either<Failure,LogInEntity>> call(LogInRequestParamsModel parameters)async{
    return await loginRepository.logIn(parameters);
  }
}

