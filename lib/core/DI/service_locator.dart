import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tabibi/features/authentication/data/datasources/auth_remote_date_source.dart';
import 'package:tabibi/features/authentication/data/repositories/authentication_repository.dart';
import 'package:tabibi/features/authentication/domain/repositories/base_authentication_repository.dart';
import 'package:tabibi/features/authentication/domain/usecases/create_new_password_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/forgot_password_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/sign_up_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/verify_code_use_case.dart';
import 'package:tabibi/features/authentication/modules/create_new_password/presentation/cubit/create_new_password_cubit.dart';
import 'package:tabibi/features/authentication/modules/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:tabibi/features/authentication/modules/signup/presentation/cubit/sign_up_cubit.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Dio
  sl.registerLazySingleton(() => Dio());

  /// DATA SOURCE
  sl.registerLazySingleton<BaseAuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSource(sl()),
  );

  /// REPOSITORY
  sl.registerLazySingleton<BaseAuthenticationRepository>(
    () => AuthenticationRepository(sl()),
  );

  /// USE CASE
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyCodeUseCase(sl()));
  sl.registerLazySingleton(() => CreateNewPasswordUseCase(sl()));

  /// CUBIT
  sl.registerFactory(() => SignUpCubit(sl()));
  sl.registerFactory(() => ForgotPasswordCubit(sl()));
  sl.registerFactory(() => VerifyCodeCubit(sl(), sl()));
  sl.registerFactory(() => CreateNewPasswordCubit(sl()));
}
