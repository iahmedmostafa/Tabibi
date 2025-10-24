import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_cubit.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_state.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/widgets/pin_code.dart';
import 'package:tabibi/features/authentication/modules/widgets/arrow_back.dart';
import 'package:tabibi/features/authentication/modules/widgets/auth_prompt_text.dart';
import 'package:tabibi/features/authentication/modules/widgets/top_section.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VerifyCodeCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<VerifyCodeCubit, VerifyCodeState>(
        listener: (context, state) {
          if (state.status == VerifyCodeStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message ?? 'Verification successful!')));
            context.go(AppRoutes.createNewPassword,extra: cubit.state.targetEmail,);
          } else if (state.status == VerifyCodeStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Verification failed!')));
          }

          if (state.resendStatus == ResendCodeStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message ?? 'Code resent successfully!')));
          } else if (state.resendStatus == ResendCodeStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Failed to resend code!')));
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
                    const ArrowBack(nameRoute: AppRoutes.forgotPassword),
                    VerticalSpace(height: AppHeight.h32),
                    const TopSection(
                      title: AppStrings.verifyCode,
                      supTitle: AppStrings.supTitleVerifyCode,
                    ),
                    VerticalSpace(height: AppHeight.h32),
                    PinCode(controller: cubit.pinController),
                    VerticalSpace(height: AppHeight.h32),
                    PrimaryButton(
                      onPress: state.status == VerifyCodeStatus.loading
                          ? null
                          : () => cubit.verifyCode(),
                      title: state.status == VerifyCodeStatus.loading
                          ? 'Verifying...'
                          : AppStrings.verify,
                    ),
                    VerticalSpace(height: AppHeight.h24),
                    AuthPromptText(
                      gestureDetectorName: state.resendStatus == ResendCodeStatus.loading
                          ? 'Sending...'
                          : AppStrings.resend,
                      text: AppStrings.didntGetCode,
                      onPress: state.resendStatus == ResendCodeStatus.loading
                          ? (){}
                          : () => cubit.resendCode(),
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