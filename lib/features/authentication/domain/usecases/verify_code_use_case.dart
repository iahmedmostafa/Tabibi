import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/authentication/domain/repositories/base_authentication_repository.dart';

class VerifyCodeUseCase extends BaseUseCase<String, VerifyCodeParameters> {
  final BaseAuthenticationRepository repository;

  VerifyCodeUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(VerifyCodeParameters parameters) async {
    return await repository.verifyCode(parameters);
  }
}

class VerifyCodeParameters extends Equatable {
  final String email;
  final String code;

  const VerifyCodeParameters({required this.email, required this.code});

  @override
  List<Object?> get props => [email, code];
}