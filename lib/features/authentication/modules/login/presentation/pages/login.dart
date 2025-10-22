import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/custom_input_field.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/authentication/modules/login/presentation/business_logic/log_in_cubit.dart';
import 'package:tabibi/features/authentication/modules/login/presentation/widgets/bottom_login_section.dart';
import 'package:tabibi/features/authentication/modules/widgets/auth_prompt_text.dart';
import 'package:tabibi/features/authentication/modules/widgets/top_section.dart';
import 'package:tabibi/features/test.dart';
import '../../../../../../core/utils/validators/validation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late LogInCubit cubit;
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
                isPassword: true,
                validator: Validator.validatePassword,
                controller:cubit.passwordController,
              ),

              VerticalSpace(height: AppHeight.h23),

              BlocListener<LogInCubit, LogInState>(
                listener: (context, state) {
                  if (state is LogInFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  } else if (state is LogInSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Logged in successfully")),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Test()),
                    );
                  }
                },
                child: BlocBuilder<LogInCubit, LogInState>(
                  builder: (context, state) {
                    if (state is LogInLoading) {
                      return const Center(child: CircularProgressIndicator());
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

              BottomLoginSection(
                onGooglePressed: () {},
                onFacebookPressed: () {},
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
                  ).textTheme.bodySmall?.copyWith(color: AppColors.blue600),
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
}
