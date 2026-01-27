import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/authentication/modules/create_new_password/presentation/cubit/create_new_password_cubit.dart';
import 'package:tabibi/features/authentication/modules/create_new_password/presentation/pages/create_new_password.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/clinic_upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/cubit/credential_upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/approved_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/doctor_fill_profile.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/new_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/pending_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/pages/rejected_page.dart';
import 'package:tabibi/features/authentication/modules/doctor_fill_profile/widgets/doctor_status_handler.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/cities_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/cubit/upload_image_cubit.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/pages/fill_profile.dart';
import 'package:tabibi/features/authentication/modules/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:tabibi/features/authentication/modules/forgot_password/presentation/pages/forgot_password.dart';
import 'package:tabibi/features/authentication/modules/login/presentation/business_logic/log_in_cubit.dart';
import 'package:tabibi/features/authentication/modules/login/presentation/pages/login.dart';
import 'package:tabibi/features/authentication/modules/signup/presentation/cubit/sign_up_cubit.dart';
import 'package:tabibi/features/authentication/modules/signup/presentation/pages/signup.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_cubit.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_state.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/pages/verify_code.dart';
import 'package:tabibi/features/home/presentation/cubit/doctor_profile_cubit.dart';
import 'package:tabibi/features/home/presentation/cubit/patient_profile_cubit.dart';
import 'package:tabibi/features/home/presentation/screen/home_screen.dart';
import 'package:tabibi/features/home/presentation/screen/patient/patient_home_screen.dart';
import 'package:tabibi/features/onboarding/presentation/screens/onboarding.dart';

import '../../features/authentication/modules/doctor_fill_profile/cubit/departments_cubit.dart';
import '../../features/authentication/modules/doctor_fill_profile/cubit/doctor_fill_profile_form_cubit.dart';
import '../services/shared_prefs_service.dart';

final GoRouter router = GoRouter(
  initialLocation: OnboardingServices.isFirstTime() ? '/onboarding' : '/patientHome',
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboarding,
      builder: (context, state) => const OnBoardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,

      builder: (context, state) {
        return BlocProvider(
          create: (context) => sl<LogInCubit>(),
          child: const LoginScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: AppRoutes.forgotPassword,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<ForgotPasswordCubit>(),
        child: const ForgotPasswordScreen(),
      ),
    ),
    GoRoute(
      path: '${AppRoutes.verifyCode}/:email',
      name: AppRoutes.verifyCode,
      builder: (context, state) {
        final email = state.pathParameters['email'] ?? '';
        final extra = state.extra;
        final originStr = (extra is Map && extra['origin'] != null)
            ? extra['origin'] as String
            : '';
        var originEnum = VerifyOrigin.unknown;
        if (originStr == 'signup') originEnum = VerifyOrigin.signup;
        if (originStr == 'forgot') originEnum = VerifyOrigin.forgot;
        return BlocProvider(
          create: (context) {
            final cubit = sl<VerifyCodeCubit>();
            cubit.setTargetEmail(email);
            if (originStr.isNotEmpty) cubit.setOrigin(originEnum);
            return cubit;
          },
          child: const VerifyCodeScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.createNewPassword,
      name: AppRoutes.createNewPassword,
      builder: (context, state) {
        final email = state.extra as String? ?? '';

        return BlocProvider(
          create: (context) {
            final cubit = sl<CreateNewPasswordCubit>();
            cubit.setTargetEmail(email);
            return cubit;
          },
          child: const CreateNewPassword(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.signUp,
      name: AppRoutes.signUp,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<SignUpCubit>(),
        child: const SignupScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.fillProfile,
      name: AppRoutes.fillProfile,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<UploadImageCubit>()),
          BlocProvider(create: (context) => sl<CitiesCubit>()..getCities()),
          BlocProvider(
            create: (context) => sl<PatientProfileCubit>()..getPatientProfile(),
          ),
        ],
        child: const FillProfile(),
      ),
    ),

    GoRoute(
      path: AppRoutes.doctorFillProfile,
      name: AppRoutes.doctorFillProfile,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<DoctorFillProfileFormCubit>()),
          BlocProvider(create: (context) => sl<UploadImageCubit>()),
          BlocProvider(create: (context) => sl<CitiesCubit>()..getCities()),
          BlocProvider(
            create: (context) => sl<DepartmentsCubit>()..getDepartments(),
          ),
          BlocProvider(create: (context) => sl<CredentialUploadImageCubit>()),
          BlocProvider(create: (context) => sl<ClinicUploadImageCubit>()),

          BlocProvider(
            create: (context) => sl<DoctorProfileCubit>()..getDoctorProfile(),
          ),
        ],
        child: const DoctorFillProfile(),
      ),
    ),

    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.patientHome,
      name: AppRoutes.patientHome,
      builder: (context, state) => PatientHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.pending,
      name: AppRoutes.pending,
      builder: (context, state) => const PendingPage(),
    ),
    GoRoute(
      path: AppRoutes.approved,
      name: AppRoutes.approved,
      builder: (context, state) => const ApprovedPage(),
    ),
    GoRoute(
      path: AppRoutes.newpage,
      name: AppRoutes.newpage,
      builder: (context, state) => const NewPage(),
    ),
    GoRoute(
      path: AppRoutes.rejected,
      name: AppRoutes.rejected,
      builder: (context, state) => const RejectedPage(),
    ),
    GoRoute(
      path: AppRoutes.doctorStatusHandler,
      name: AppRoutes.doctorStatusHandler,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<DoctorProfileCubit>()..getDoctorStatus(),
        child: const DoctorStatusHandler(),
      ),
    ),
  ],
);
