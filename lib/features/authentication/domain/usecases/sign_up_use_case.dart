import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/authentication/domain/repositories/base_authentication_repository.dart';

class SignUpUseCase extends BaseUseCase<String, SignUpParameters> {
  final BaseAuthenticationRepository repository;
  SignUpUseCase(this.repository);
  @override
  Future<Either<Failure, String>> call(SignUpParameters parameters) async {
    return await repository.signup(parameters);
  }
}

class SignUpParameters extends Equatable {
  final String userName;
  final String email;
  final String password;
  final int role;

  const SignUpParameters({
    required this.userName,
    required this.email,
    required this.password,
    required this.role
  });

  @override
  List<Object?> get props => [userName,  email, password,role];
}
