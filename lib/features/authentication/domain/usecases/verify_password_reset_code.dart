import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/authentication/domain/repositories/base_authentication_repository.dart';
import 'package:tabibi/features/authentication/domain/usecases/verify_code_use_case.dart';

class VerifyPasswordResetCodeUseCase
    extends BaseUseCase<String, VerifyCodeParameters> {
  final BaseAuthenticationRepository repository;
  VerifyPasswordResetCodeUseCase(this.repository);
  @override
  Future<Either<Failure, String>> call(VerifyCodeParameters parameters) async {
    return await repository.verifyPasswordResetCode(parameters);
  }
}
