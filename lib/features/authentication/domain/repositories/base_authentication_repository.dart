import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';

abstract class BaseAuthenticationRepository {
  Future<Either<Failure,String>> signup(
    String firstName,
    String lastName,
    String email,
    String password,
  );
}