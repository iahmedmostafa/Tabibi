import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/authentication/presentation/screens/create_new_password/create_new_password.dart';
import 'package:tabibi/features/authentication/presentation/screens/fill_profile/fill_profile.dart';
import 'package:tabibi/features/authentication/presentation/screens/forgot_password/forgot_password.dart';
import 'package:tabibi/features/authentication/presentation/screens/login/login.dart';
import 'package:tabibi/features/authentication/presentation/screens/signup/signup.dart';
import 'package:tabibi/features/authentication/presentation/screens/verify_code/verify_code.dart';
import 'package:tabibi/features/onboarding/presentation/screens/onboarding.dart';
import '../services/shared_prefs_service.dart';

final GoRouter router = GoRouter(
  initialLocation: onboardingServices.isFirstTime()
      ? '/onboarding'
      : '/login',
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
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.verifyCode,
      name: AppRoutes.verifyCode,
      builder: (context, state) => const VerifyCodeScreen(),
    ),
    GoRoute(
      path: AppRoutes.createNewPassword,
      name: AppRoutes.createNewPassword,
      builder: (context, state) => const CreateNewPassword(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      name: AppRoutes.signUp,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.fillProfile,
      name: AppRoutes.fillProfile,
      builder: (context, state) => const FillProfile(),
    ),
  ],
);
