import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
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
import 'package:tabibi/features/authentication/modules/create_new_password/presentation/cubit/create_new_password_cubit.dart';
import 'package:tabibi/features/authentication/modules/create_new_password/presentation/cubit/create_new_password_state.dart';
import 'package:tabibi/features/authentication/modules/widgets/top_section.dart';

class CreateNewPassword extends StatelessWidget {
  const CreateNewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateNewPasswordCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<CreateNewPasswordCubit, CreateNewPasswordState>(
        listener: (context, state) {
          if (state.status == CreatePasswordStatus.success) {
            AppHelperFunctions.showAwesomeSnackBar(
              title: 'success'.tr(),
              message: state.message ?? "success",
              contentType: ContentType.success,
              context: context,
            );

            context.go(AppRoutes.login);
          } else if (state.status == CreatePasswordStatus.failure) {
            AppHelperFunctions.showAwesomeSnackBar(
              title: 'error'.tr(),
              message: state.errorMessage ?? "failure",
              contentType: ContentType.failure,
              context: context,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  children: [
                    VerticalSpace(height: AppHeight.h32),
                    const ArrowBack(nameRoute: AppRoutes.verifyCode),
                    VerticalSpace(height: AppHeight.h32),
                    TopSection(
                      title: AppStrings.createNewPassword,
                      supTitle: AppStrings.supTitleCreateNewPassword,
                    ),
                    VerticalSpace(height: AppHeight.h32),
                    CustomInputField(
                      hintText: AppStrings.password,
                      icon: Iconsax.password_check,
                      controller: cubit.passwordController,
                      validator: Validator.validatePassword,
                      isPassword: true,
                    ),
                    VerticalSpace(height: AppHeight.h20),
                    CustomInputField(
                      hintText: AppStrings.confirmPassword,
                      icon: Iconsax.password_check,
                      controller: cubit.confirmPasswordController,
                      validator: (value) => Validator.validateConfirmPassword(
                        value,
                        cubit.confirmPasswordController.text,
                      ),
                      isPassword: true,
                    ),
                    VerticalSpace(height: AppHeight.h32),
                    PrimaryButton(
                      onPress: state.status == CreatePasswordStatus.loading
                          ? () {}
                          : () => cubit.createNewPassword(),
                      title: state.status == CreatePasswordStatus.loading
                          ? 'creating'.tr()
                          : AppStrings.resetPassword,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
