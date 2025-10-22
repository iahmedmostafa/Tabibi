import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tabibi/features/authentication/data/datasources/auth_remote_date_source.dart';
import 'package:tabibi/features/authentication/data/repositories/authentication_repository.dart';
import 'package:tabibi/features/authentication/domain/repositories/base_authentication_repository.dart';
import 'package:tabibi/features/authentication/domain/usecases/log_in_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/sign_up_use_case.dart';
import 'package:tabibi/features/authentication/modules/login/presentation/business_logic/log_in_cubit.dart';
import 'package:tabibi/features/authentication/modules/signup/presentation/cubit/sign_up_cubit.dart';

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
    () => AuthenticationRepositoryImpl(sl()),
  );

  /// USE CASE
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => LogInUseCase(sl()));

  /// CUBIT
  sl.registerFactory(() => SignUpCubit(sl()));
  sl.registerFactory(() => LogInCubit(sl()));

}
