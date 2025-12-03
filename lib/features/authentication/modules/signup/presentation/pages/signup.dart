import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_images.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/core/utils/validators/validation.dart';
import 'package:tabibi/core/widgets/custom_input_field.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/authentication/modules/signup/presentation/cubit/sign_up_cubit.dart';
import 'package:tabibi/features/authentication/modules/signup/presentation/cubit/sign_up_state.dart';
import 'package:tabibi/features/authentication/modules/widgets/auth_prompt_text.dart';
import 'package:tabibi/features/authentication/modules/widgets/or_section.dart';
import 'package:tabibi/features/authentication/modules/widgets/social_button.dart';
import 'package:tabibi/features/authentication/modules/widgets/top_section.dart';

import '../../../../../../core/services/cache_helper.dart';
import '../../../../../../core/widgets/drop_menu.dart/drop_menu.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late SignUpCubit cubit;
  int role = 1;
  @override
  Widget build(BuildContext context) {
    cubit = context.read<SignUpCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
        child: Form(
          key: cubit.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                VerticalSpace(height: AppHeight.h85),
                const TopSection(
                  title: AppStrings.createAccount,
                  supTitle: AppStrings.subTitleCreateAccount,
                ),

                VerticalSpace(height: AppHeight.h32),
                CustomInputField(
                  hintText: AppStrings.email,
                  controller: cubit.emailController,
                  icon: Iconsax.sms,
                  // pass the validator function itself (signature: String? Function(String?))
                  validator: Validator.validateEmail,
                  isPassword: false,
                ),

                VerticalSpace(height: AppHeight.h20),
                CustomInputField(
                  hintText: AppStrings.name,
                  controller: cubit.nameController,
                  icon: Iconsax.user,
                  // pass a validator closure so it matches String? Function(String?)?
                  validator: (value) =>
                      Validator.validateEmptyText("Name", value),
                  isPassword: false,
                ),

                VerticalSpace(height: AppHeight.h20),
                CustomInputField(
                  hintText: AppStrings.password,
                  controller: cubit.passwordController,
                  validator: Validator.validatePassword,
                  icon: Iconsax.password_check,
                  isPassword: true,
                ),
                VerticalSpace(height: AppHeight.h24),
                // DropMenu for role selection
                DropMenu(
                  hint: AppStrings.selectRole,
                  items: const ['Patient', 'Doctor'],
                  onChanged: (value) async {
                    setState(() {
                      role = value == 'Patient' ? 1 : 2;
                    });
                    await CacheHelper.saveData(
                      key: 'role',
                      value: role.toString(),
                    );
                  },
                  value: role == 1 ? 'Patient' : 'Doctor',
                ),

                VerticalSpace(height: AppHeight.h24),
                BlocConsumer<SignUpCubit, SignUpState>(
                  listener: (context, state) {
                    if (state.status == SignUpStatus.success) {
                      // navigate to verify code page with email and origin
                      AppHelperFunctions.showAwesomeSnackBar(
                        title: 'Success',
                        message: state.message!,
                        contentType: ContentType.success,
                        context: context,
                      );
                      // navigate using a full path to avoid name-based mismatches
                      context.go(
                        '${AppRoutes.verifyCode}/${cubit.emailController.text}',
                        extra: {'origin': 'signup'},
                      );
                    } else if (state.status == SignUpStatus.failure) {
                      final msg = state.errorMessage ?? 'Sign up failed';
                      AppHelperFunctions.showAwesomeSnackBar(
                        title: 'Error',
                        message: msg,
                        contentType: ContentType.failure,
                        context: context,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.status == SignUpStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return PrimaryButton(
                      onPress: () {
                        cubit.signUp(role);
                      },
                      title: AppStrings.createAccount,
                    );
                  },
                ),

                VerticalSpace(height: AppHeight.h24),
                const OrSection(),

                const VerticalSpace(height: 24),
                SocialButton(
                  text: AppStrings.signWithGoogle,
                  iconPath: AppImages.google,
                  onPressed: () {},
                ),

                VerticalSpace(height: AppHeight.h16),
                SocialButton(
                  text: AppStrings.signWithFacebook,
                  iconPath: AppImages.facebook,
                  onPressed: () {},
                ),

                VerticalSpace(height: AppHeight.h24),
                AuthPromptText(
                  text: AppStrings.haveAccount,
                  gestureDetectorName: AppStrings.signIn,
                  onPress: () {
                    context.go(AppRoutes.login);
                  },
                ),
                VerticalSpace(height: AppHeight.h24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
