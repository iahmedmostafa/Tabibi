import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/services/shared_prefs_service.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/doctor_profile/domain/usecases/doctor_status_use_case.dart';

class StartupGateScreen extends StatefulWidget {
  const StartupGateScreen({super.key});

  @override
  State<StartupGateScreen> createState() => _StartupGateScreenState();
}

class _StartupGateScreenState extends State<StartupGateScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resolveInitialRoute();
    });
  }

  Future<void> _resolveInitialRoute() async {
    if (!mounted) return;

    if (OnboardingServices.isFirstTime()) {
      context.goNamed(AppRoutes.onboarding);
      return;
    }

    if (!OnboardingServices.isLoggedIn()) {
      context.goNamed(AppRoutes.login);
      return;
    }

    final role = OnboardingServices.getRole();
    if (role == '2') {
      final result = await sl<DoctorStatusUseCase>()();

      if (!mounted) return;

      result.fold(
        (_) => context.goNamed(AppRoutes.doctorStatusHandler),
        (status) {
          switch (status) {
            case DoctorStatus.New:
              context.goNamed(AppRoutes.doctorFillProfile);
              break;
            case DoctorStatus.Pending:
              context.goNamed(AppRoutes.pending);
              break;
            case DoctorStatus.Approved:
              context.goNamed(AppRoutes.homeDoctorScreen);
              break;
            case DoctorStatus.Rejected:
              context.goNamed(AppRoutes.rejected);
              break;
          }
        },
      );
      return;
    }

    context.goNamed(
      OnboardingServices.isProfileFilled()
          ? AppRoutes.bottomNavScreen
          : AppRoutes.fillProfile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: isDark ? AppColors.teal20 : AppColors.primary,
        ),
      ),
    );
  }
}
