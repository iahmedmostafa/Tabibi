import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tabibi/core/services/location_services.dart';
import 'package:tabibi/features/authentication/data/datasources/auth_remote_date_source.dart';
import 'package:tabibi/features/authentication/data/datasources/cities_data_source.dart';
import 'package:tabibi/features/authentication/data/datasources/departments_data_source.dart';
import 'package:tabibi/features/authentication/data/datasources/upload_image_data_source.dart';
import 'package:tabibi/features/authentication/data/repositories/authentication_repository.dart';
import 'package:tabibi/features/authentication/data/repositories/cities_repository.dart';
import 'package:tabibi/features/authentication/data/repositories/department_repo.dart';
import 'package:tabibi/features/authentication/data/repositories/upload_image_repositary.dart';
import 'package:tabibi/features/authentication/domain/repositories/base_authentication_repository.dart';
import 'package:tabibi/features/authentication/domain/usecases/create_new_password_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/forgot_password_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/log_in_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/sign_up_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/verify_code_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/verify_password_reset_code.dart';
import 'package:tabibi/features/authentication/modules/create_new_password/presentation/cubit/create_new_password_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/clinic_location_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/clinic_upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/credential_upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/cities_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:tabibi/features/authentication/modules/login/presentation/business_logic/log_in_cubit.dart';
import 'package:tabibi/features/authentication/modules/signup/presentation/cubit/sign_up_cubit.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_cubit.dart';
import 'package:tabibi/features/home/data/datasources/base_doctor_profile_data_source.dart';
import 'package:tabibi/features/home/data/datasources/base_patient_profile_data_source.dart';
import 'package:tabibi/features/home/data/datasources/doctor_profile_data_source.dart';
import 'package:tabibi/features/home/data/datasources/patient_profile_data_source.dart';
import 'package:tabibi/features/home/data/repositories/doctor_profile_repository.dart';
import 'package:tabibi/features/home/data/repositories/patient_profile_repository.dart';
import 'package:tabibi/features/home/domain/repositories/base_doctor_profile_repository.dart';
import 'package:tabibi/features/home/domain/repositories/base_patient_profile_repository.dart';
import 'package:tabibi/features/home/domain/usecases/doctor_status_use_case.dart';
import 'package:tabibi/features/home/domain/usecases/get_doctor_profile_use_case.dart';
import 'package:tabibi/features/home/domain/usecases/get_patient_profile_use_case.dart';
import 'package:tabibi/features/home/domain/usecases/update_doctor_profile_use_case.dart';
import 'package:tabibi/features/home/domain/usecases/update_patient_profile_use_case.dart';
import 'package:tabibi/features/home/presentation/cubit/doctor_profile_cubit.dart';
import 'package:tabibi/features/home/presentation/cubit/patient_profile_cubit.dart';

import '../../features/authentication/modules/doctor_fill_profile/cubit/departments_cubit.dart';
import '../../features/authentication/modules/doctor_fill_profile/cubit/doctor_fill_profile_form_cubit.dart';
import '../services/cache_helper.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //location services
  sl.registerLazySingleton(() => LocationServices());
  //cache helper
  sl.registerLazySingleton(() => sl<CacheHelper>());

  //Dio
  sl.registerLazySingleton(() => Dio());

  /// DATA SOURCE
  sl.registerLazySingleton<BaseAuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSource(sl()),
  );
  sl.registerLazySingleton(() => UploadImageDataSource(sl()));
  sl.registerLazySingleton(() => CitiesDataSource(sl()));
  sl.registerLazySingleton(() => DepartmentsDataSource(sl()));
  sl.registerLazySingleton<BasePatientProfileDataSource>(
    () => PatientProfileDataSource(sl()),
  );
  sl.registerLazySingleton<BaseDoctorProfileDataSource>(
    () => DoctorProfileDataSource(sl()),
  );

  /// REPOSITORY
  sl.registerLazySingleton<BaseAuthenticationRepository>(
    () => AuthenticationRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => UploadImageRepositary(sl()));
  sl.registerLazySingleton(() => CitiesRepository(sl()));
  sl.registerLazySingleton<BasePatientProfileRepository>(
    () => PatientProfileRepository(sl()),
  );
  sl.registerLazySingleton<BaseDoctorProfileRepository>(
    () => DoctorProfileRepository(sl()),
  );
  sl.registerLazySingleton(() => DepartmentRepository(sl()));

  /// USE CASE
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyCodeUseCase(sl()));
  sl.registerLazySingleton(() => VerifyPasswordResetCodeUseCase(sl()));
  sl.registerLazySingleton(() => CreateNewPasswordUseCase(sl()));
  sl.registerLazySingleton(() => LogInUseCase(sl()));
  sl.registerLazySingleton(() => GetPatientProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePatientProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetDoctorProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateDoctorProfileUseCase(sl()));
  sl.registerLazySingleton(() => DoctorStatusUseCase(sl()));

  /// CUBIT
  sl.registerFactory(() => SignUpCubit(sl()));
  sl.registerFactory(() => ForgotPasswordCubit(sl()));
  sl.registerFactory(() => VerifyCodeCubit(sl(), sl(), sl()));
  sl.registerFactory(() => CreateNewPasswordCubit(sl()));
  sl.registerFactory(() => LogInCubit(sl()));
  sl.registerFactory(() => UploadImageCubit(sl()));
  sl.registerFactory(() => CredentialUploadImageCubit(sl()));
  sl.registerFactory(() => ClinicUploadImageCubit(sl()));
  sl.registerFactory(() => CitiesCubit(sl()));
  sl.registerFactory(() => PatientProfileCubit(sl(), sl()));
  sl.registerFactory(() => DoctorProfileCubit(sl(), sl(), sl()));
  sl.registerFactory(() => DepartmentsCubit(sl()));
  sl.registerFactory(() => DoctorFillProfileFormCubit());
  sl.registerFactory(() => ClinicLocationCubit(sl<LocationServices>()));
}
