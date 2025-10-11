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
    return await repository.signup(
      parameters.firstName,
      parameters.lastName,
      parameters.email,
      parameters.password,
    );
  }
}

class SignUpParameters extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const SignUpParameters({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, password];
}
