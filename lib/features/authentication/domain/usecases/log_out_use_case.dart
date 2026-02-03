import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/authentication/domain/repositories/base_authentication_repository.dart';

class LogOutUseCase extends BaseUseCase<void, NoParameters> {
  final BaseAuthenticationRepository baseAuthenticationRepository;

  LogOutUseCase(this.baseAuthenticationRepository);

  @override
  Future<Either<Failure, void>> call(NoParameters parameters) async {
    return await baseAuthenticationRepository.logOut();
  }
}
