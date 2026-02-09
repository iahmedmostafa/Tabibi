import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tabibi/core/network/api_constance.dart';
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
import 'package:tabibi/features/authentication/domain/usecases/log_out_use_case.dart';
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
import 'package:tabibi/features/booking/data/datasources/appointment_remote_data_source.dart';
import 'package:tabibi/features/booking/data/datasources/booking_data_source.dart';
import 'package:tabibi/features/booking/data/repositories/appointment_repository_impl.dart';
import 'package:tabibi/features/booking/data/repositories/booking_repo_impl.dart';
import 'package:tabibi/features/booking/domain/repositories/appointment_repository.dart';
import 'package:tabibi/features/booking/domain/repositories/base_booking_repo.dart';
import 'package:tabibi/features/booking/domain/usecases/cancel_booking_use_case.dart';
import 'package:tabibi/features/booking/domain/usecases/confirm_payment_use_case.dart';
import 'package:tabibi/features/booking/domain/usecases/create_booking_use_case.dart';
import 'package:tabibi/features/booking/domain/usecases/get_available_slots_use_case.dart';
import 'package:tabibi/features/booking/domain/usecases/get_my_bookings.dart';
import 'package:tabibi/features/booking/presentation/controller/appointment_cubit.dart';
import 'package:tabibi/features/booking/presentation/controller/my_bookings_cubit.dart';
import 'package:tabibi/features/doctor_details/data/datasources/doctor_details_remote_data_source.dart';
import 'package:tabibi/features/doctor_details/data/repositories/doctor_details_repository_impl.dart';
import 'package:tabibi/features/doctor_details/domain/repositories/doctor_details_repository.dart';
import 'package:tabibi/features/doctor_details/domain/usecases/get_doctor_details_use_case.dart';
import 'package:tabibi/features/doctor_details/presentation/controller/doctor_details_cubit.dart';
import 'package:tabibi/features/doctor_profile/data/datasources/base_doctor_profile_data_source.dart';
import 'package:tabibi/features/doctor_profile/data/datasources/doctor_profile_data_source.dart';
import 'package:tabibi/features/doctor_profile/data/repositories/doctor_profile_repository.dart';
import 'package:tabibi/features/doctor_profile/domain/repositories/base_doctor_profile_repository.dart';
import 'package:tabibi/features/doctor_profile/domain/usecases/doctor_status_use_case.dart';
import 'package:tabibi/features/doctor_profile/domain/usecases/get_doctor_profile_use_case.dart';
import 'package:tabibi/features/doctor_profile/domain/usecases/update_doctor_profile_use_case.dart';
import 'package:tabibi/features/doctor_profile/presentation/controller/doctor_profile_cubit.dart';
import 'package:tabibi/features/doctors_map/data/datasources/doctor_map_remote_data_source.dart';
import 'package:tabibi/features/doctors_map/data/repositories/doctor_map_repository.dart';
import 'package:tabibi/features/doctors_map/presentation/controller/doctor_map_cubit.dart';
import 'package:tabibi/features/favorite/data/repositories/favorites_repository_impl.dart';
import 'package:tabibi/features/favorite/domain/repositories/favorites_repository.dart';
import 'package:tabibi/features/favorite/domain/usecases/get_favorites_use_case.dart';
import 'package:tabibi/features/favorite/presentation/controller/favorites_cubit.dart';
import 'package:tabibi/features/home/data/datasources/doctors_remote_data_source.dart';
import 'package:tabibi/features/home/data/repositories/doctor_repository.dart';
import 'package:tabibi/features/home/data/repositories/notifications_repository_impl.dart';
import 'package:tabibi/features/home/domain/repositories/notifications_repository.dart';
import 'package:tabibi/features/home/domain/usecases/get_notifications_use_case.dart';
import 'package:tabibi/features/home/presentation/cubit/notifications_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/patient/cubit/doctors_cubit.dart';
import 'package:tabibi/features/patient_profile/data/datasources/base_patient_profile_data_source.dart';
import 'package:tabibi/features/patient_profile/data/datasources/patient_profile_data_source.dart';
import 'package:tabibi/features/patient_profile/data/repositories/patient_profile_repository.dart';
import 'package:tabibi/features/patient_profile/domain/repositories/base_patient_profile_repository.dart';
import 'package:tabibi/features/patient_profile/domain/usecases/get_patient_profile_use_case.dart';
import 'package:tabibi/features/patient_profile/domain/usecases/update_patient_profile_use_case.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/patient_profile_cubit.dart';
import 'package:tabibi/features/patient_profile/presentation/controller/profile_cubit.dart';

import '../../features/authentication/modules/doctor_fill_profile/cubit/departments_cubit.dart';
import '../../features/authentication/modules/doctor_fill_profile/cubit/doctor_fill_profile_form_cubit.dart';
import '../../features/home/data/datasources/departments_data_source.dart'
    as home_ds;
import '../../features/home/data/repositories/department_repo.dart'
    as home_repo;
import '../../features/home/presentation/screen/patient/cubit/departments_cubit.dart'
    as home_cubit;
import '../services/cache_helper.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //location services
  sl.registerLazySingleton(() => LocationServices());
  //cache helper
  sl.registerLazySingleton(() => sl<CacheHelper>());

  //Dio
  sl.registerLazySingleton(
    () => Dio(BaseOptions(baseUrl: ApiConstance.baseUrl)),
  );

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
  sl.registerLazySingleton<DoctorsRemoteDataSource>(
    () => DoctorsRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<DoctorMapRemoteDataSource>(
    () => DoctorMapRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<DoctorDetailsRemoteDataSource>(
    () => DoctorDetailsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<BaseBookingDataSource>(
    () => BookingDataSource(sl()),
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
  sl.registerLazySingleton<DoctorsRepository>(
    () => DoctorsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<DoctorMapRepository>(
    () => DoctorMapRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<DoctorDetailsRepository>(
    () => DoctorDetailsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<BaseBookingRepo>(
    () => BookingRepoImpl(sl()),
  );

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
  sl.registerLazySingleton(() => GetDoctorDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetAvailableSlotsUseCase(sl()));
  sl.registerLazySingleton(() => CreateBookingUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmPaymentUseCase(sl()));
  sl.registerLazySingleton(() => CancelBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetMyBookingsUseCase(sl()));

  sl.registerLazySingleton(() => LogOutUseCase(sl()));

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
  sl.registerLazySingleton(() => home_ds.DepartmentsDataSource(sl()));
  sl.registerLazySingleton(() => home_repo.DepartmentRepository(sl()));
  sl.registerFactory(() => home_cubit.DepartmentsCubit(sl()));
  sl.registerFactory(() => DoctorFillProfileFormCubit());
  sl.registerFactory(() => ClinicLocationCubit(sl<LocationServices>()));
  sl.registerFactory(() => DoctorsCubit(sl()));
  sl.registerFactory(() => AppointmentCubit(sl(), sl(), sl(), sl()));
  sl.registerLazySingleton(() => MyBookingsCubit(sl()));
  sl.registerFactory(() => DoctorMapCubit(sl<DoctorMapRepository>()));
  sl.registerFactory(() => DoctorDetailsCubit(sl()));

  // Profile (New)
  sl.registerFactory(
    () => ProfileCubit(logOutUseCase: sl(), getPatientProfileUseCase: sl()),
  );
  // Notifications & Favorites Repositories
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(),
  );
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(),
  );

  // UseCases
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));

  // Cubits
  sl.registerFactory(() => NotificationsCubit(sl()));
  sl.registerFactory(() => FavoritesCubit(sl()));
  sl.registerFactory(() => DoctorMapCubit(sl()));
}
