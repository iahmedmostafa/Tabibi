import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/authentication/modules/create_new_password/presentation/cubit/create_new_password_cubit.dart';
import 'package:tabibi/features/authentication/modules/create_new_password/presentation/pages/create_new_password.dart';
import 'package:tabibi/features/authentication/modules/fill_profile/presentation/pages/fill_profile.dart';
import 'package:tabibi/features/authentication/modules/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:tabibi/features/authentication/modules/forgot_password/presentation/pages/forgot_password.dart';
import 'package:tabibi/features/authentication/modules/login/presentation/pages/login.dart';
import 'package:tabibi/features/authentication/modules/signup/presentation/cubit/sign_up_cubit.dart';
import 'package:tabibi/features/authentication/modules/signup/presentation/pages/signup.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_cubit.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/pages/verify_code.dart';
import 'package:tabibi/features/onboarding/presentation/screens/onboarding.dart';
import '../services/shared_prefs_service.dart';

final GoRouter router = GoRouter(
  initialLocation: OnboardingServices.isFirstTime() ? '/onboarding' : '/login',
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboarding,
      builder: (context, state) => const OnBoardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
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
        return BlocProvider(
          create: (context) {
            final cubit = sl<VerifyCodeCubit>();
            cubit.setTargetEmail(email);
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
      builder: (context, state) => const FillProfile(),
    ),
  ],
);
