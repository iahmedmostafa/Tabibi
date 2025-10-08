import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import '../../../../core/services/shared_prefs_service.dart';
part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  final PageController pageController = PageController();
  int currentPage = 0;

  void onPageChanged(int index) {
    currentPage = index;
    emit(OnboardingPageChanged(index));
  }

  Future<void> nextPage(BuildContext context, int totalPages) async {
    if (currentPage < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      await _finishOnboarding(context);
    }
  }

  Future<void> skip(BuildContext context) async {
    await _finishOnboarding(context);
  }

  Future<void> _finishOnboarding(BuildContext context) async {
    await OnboardingServices.setSeen();
    if (context.mounted) {
      context.goNamed(AppRoutes.login);
    }
  }
  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
