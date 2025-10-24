import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/authentication/domain/repositories/base_authentication_repository.dart';

class CreateNewPasswordUseCase extends BaseUseCase<String, CreateNewPasswordParameters> {
  final BaseAuthenticationRepository repository;

  CreateNewPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(CreateNewPasswordParameters parameters) async {
    return await repository.createNewPassword(parameters);
  }
}

class CreateNewPasswordParameters extends Equatable {
  final String email;
  final String newPassword;
  final String confirmPassword;

  const CreateNewPasswordParameters({
    required this.email,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, newPassword, confirmPassword];
}