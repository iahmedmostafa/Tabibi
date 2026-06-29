import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/network/server_connection.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/core/widgets/custom_input_field.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/authentication/modules/login/presentation/business_logic/log_in_cubit.dart';
import 'package:tabibi/features/authentication/modules/widgets/auth_prompt_text.dart';
import 'package:tabibi/features/authentication/modules/widgets/top_section.dart';
import 'package:tabibi/features/doctor_profile/domain/usecases/doctor_status_use_case.dart';

import '../../../../../../core/services/shared_prefs_service.dart';
import '../../../../../../core/utils/validators/validation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LogInCubit cubit;
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    cubit = context.read<LogInCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: cubit.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              VerticalSpace(height: AppHeight.h85),

              const TopSection(
                title: AppStrings.welcome,
                supTitle: AppStrings.hope,
              ),

              VerticalSpace(height: AppHeight.h32),

              CustomInputField(
                hintText: AppStrings.email,
                icon: Iconsax.sms,
                isPassword: false,
                controller: cubit.emailController,
                validator: (value) =>
                    Validator.validateEmptyText("Email", value),
              ),

              VerticalSpace(height: AppHeight.h20),

              CustomInputField(
                hintText: AppStrings.password,
                icon: Iconsax.password_check,
                validator: (value) =>
                    Validator.validateEmptyText("Password", value),
                isPassword: isPasswordVisible,
                suffixIcon: isPasswordVisible ? Iconsax.eye_slash : Iconsax.eye,
                onpressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                controller: cubit.passwordController,
              ),

              VerticalSpace(height: AppHeight.h23),

              BlocListener<LogInCubit, LogInState>(
                listener: (context, state) async {
                  if (state is LogInFailure) {
                    AppHelperFunctions.showAwesomeSnackBar(
                      title: 'Error',
                      message: state.errorMessage,
                      contentType: ContentType.failure,
                      context: context,
                    );
                  } else if (state is LogInSuccess) {
                    AppHelperFunctions.showAwesomeSnackBar(
                      title: 'Success',
                      message: "Logged in successfully",
                      contentType: ContentType.success,
                      context: context,
                    );
                    await ServerConnection().connect(
                      accessToken: state.logInEntity.accessToken,
                    );
                    if (state.role == '2') {
                      await _handleDoctorNavigation(context);
                    } else {
                      if (OnboardingServices.isProfileFilled()) {
                        context.go(AppRoutes.bottomNavScreen);
                      } else {
                        context.go(AppRoutes.fillProfile);
                      }
                    }
                  }
                },
                child: BlocBuilder<LogInCubit, LogInState>(
                  buildWhen: (previous, current) =>
                      current is LogInLoading || current is LogInInitial,
                  builder: (context, state) {
                    if (state is LogInLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    return PrimaryButton(
                      onPress: () {
                        cubit.logIn();
                      },
                      title: AppStrings.signIn,
                    );
                  },
                ),
              ),

              VerticalSpace(height: AppHeight.h23),

              GestureDetector(
                onTap: () {
                  context.go(AppRoutes.forgotPassword);
                },
                child: Text(
                  AppStrings.forgotPassword,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.grey600),
                ),
              ),

              VerticalSpace(height: AppHeight.h23),
              AuthPromptText(
                text: AppStrings.dontHaveAccount,
                gestureDetectorName: AppStrings.signUp,
                onPress: () {
                  context.go(AppRoutes.signUp);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleDoctorNavigation(BuildContext context) async {
    final result = await sl<DoctorStatusUseCase>()();

    if (!mounted) return;

    result.fold(
      (failure) {
        AppHelperFunctions.showAwesomeSnackBar(
          title: 'Error',
          message: failure.message,
          contentType: ContentType.failure,
          context: context,
        );
        context.go(AppRoutes.doctorFillProfile);
      },
      (status) {
        switch (status) {
          case DoctorStatus.New:
            context.go(AppRoutes.doctorFillProfile);
            break;
          case DoctorStatus.Pending:
            context.go(AppRoutes.doctorStatusHandler);
            break;
          case DoctorStatus.Approved:
            context.go(AppRoutes.homeDoctorScreen);
            break;
          case DoctorStatus.Rejected:
            context.go(AppRoutes.rejected);
            break;
        }
      },
    );
  }
}
