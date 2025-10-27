import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/authentication/domain/repositories/base_authentication_repository.dart';

class ForgotPasswordUseCase
    extends BaseUseCase<String, ForgotPasswordParameters> {
  final BaseAuthenticationRepository repository;
  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(
    ForgotPasswordParameters parameters,
  ) async {
    return await repository.forgotPassword(parameters);
  }
}

class ForgotPasswordParameters extends Equatable {
  final String email;
  final String? userName;
  final String? password;
  const ForgotPasswordParameters({
    required this.email,
    this.userName,
    this.password,
  });

  @override
  List<Object?> get props => [email, userName, password];
}
