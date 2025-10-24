import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get_it/get_it.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/validators/validation.dart';
import 'package:tabibi/core/widgets/custom_input_field.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/authentication/modules/widgets/arrow_back.dart';
import 'package:tabibi/features/authentication/modules/widgets/top_section.dart';
import 'package:tabibi/features/authentication/modules/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:tabibi/features/authentication/modules/forgot_password/presentation/cubit/forgot_password_state.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = GetIt.instance<ForgotPasswordCubit>();

    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
            child: Form(
              key: cubit.formKey,
              child: Column(
                children: [
                  VerticalSpace(height: AppHeight.h32),
                  const ArrowBack(nameRoute: AppRoutes.login),
                  VerticalSpace(height: AppHeight.h32),
                  const TopSection(
                    title: AppStrings.forgotPassword,
                    supTitle: AppStrings.supTitleForgotPassword,
                  ),
                  VerticalSpace(height: AppHeight.h32),
                  CustomInputField(
                    hintText: AppStrings.email,
                    icon: Iconsax.sms,
                    controller: cubit.emailController,
                    validator: Validator.validateEmail,
                    isPassword: false,
                  ),
                  VerticalSpace(height: AppHeight.h32),
                  BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                    listener: (context, state) {
                      if (state.status == ForgotPasswordStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.message ?? 'Code sent successfully',
                            ),
                          ),
                        );
                        context.goNamed(
                          AppRoutes.verifyCode,
                          pathParameters: {'email': cubit.emailController.text},
                        );
                      } else if (state.status == ForgotPasswordStatus.failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.errorMessage ?? 'Error occurred',
                            ),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return PrimaryButton(
                        onPress: state.status == ForgotPasswordStatus.loading
                            ? null
                            : () => cubit.sendCode(),
                        title: state.status == ForgotPasswordStatus.loading
                            ? 'Sending...'
                            : AppStrings.sendCode,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
