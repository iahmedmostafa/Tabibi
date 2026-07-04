import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/DI/service_locator.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/core/utils/validators/validation.dart';
import 'package:tabibi/core/widgets/arrow_back.dart';
import 'package:tabibi/core/widgets/custom_input_field.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/authentication/modules/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:tabibi/features/authentication/modules/forgot_password/presentation/cubit/forgot_password_state.dart';
import 'package:tabibi/features/authentication/modules/widgets/top_section.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = sl<ForgotPasswordCubit>();

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
                  TopSection(
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
                        AppHelperFunctions.showAwesomeSnackBar(
                          title: 'success'.tr(),
                          message: 'codeSentSuccessfully'.tr(),
                          contentType: ContentType.success,
                          context: context,
                        );
                        context.go(
                          '${AppRoutes.verifyCode}/${cubit.emailController.text}',
                          extra: {'origin': 'forgot'},
                        );
                      } else if (state.status == ForgotPasswordStatus.failure) {
                        AppHelperFunctions.showAwesomeSnackBar(
                          title: 'error'.tr(),
                          message: state.errorMessage ?? 'Error occurred',
                          contentType: ContentType.failure,
                          context: context,
                        );
                      }
                    },
                    builder: (context, state) {
                      return PrimaryButton(
                        onPress: state.status == ForgotPasswordStatus.loading
                            ? null
                            : () => cubit.sendCode(),
                        title: state.status == ForgotPasswordStatus.loading
                            ? 'sending'.tr()
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
