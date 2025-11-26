import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/style/spacing/vertical_space.dart';
import 'package:tabibi/core/utils/constants/app_dimensions.dart';
import 'package:tabibi/core/utils/constants/app_padding.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/arrow_back.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_cubit.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_state.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/widgets/pin_code.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/widgets/resend_code_text.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/widgets/verify_code_button.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/widgets/verify_code_listeners.dart';
import 'package:tabibi/features/authentication/modules/widgets/top_section.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VerifyCodeCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: VerifyCodeListeners(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
            child: Form(
              key: cubit.formKey,
              child: Column(
                children: [
                  VerticalSpace(height: AppHeight.h32),
                  BlocSelector<VerifyCodeCubit, VerifyCodeState, VerifyOrigin>(
                    selector: (state) => state.origin,
                    builder: (context, origin) {
                      return ArrowBack(
                        nameRoute: origin == VerifyOrigin.forgot
                            ? AppRoutes.forgotPassword
                            : AppRoutes.signUp,
                      );
                    },
                  ),
                  VerticalSpace(height: AppHeight.h32),
                  BlocSelector<VerifyCodeCubit, VerifyCodeState, VerifyOrigin>(
                    selector: (state) => state.origin,
                    builder: (context, origin) {
                      return TopSection(
                        title: AppStrings.verifyCode,
                        supTitle: origin == VerifyOrigin.signup
                            ? AppStrings.supTitleSignupVerify
                            : AppStrings.supTitleVerifyCode,
                      );
                    },
                  ),
                  VerticalSpace(height: AppHeight.h32),
                  PinCode(controller: cubit.pinController),
                  VerticalSpace(height: AppHeight.h32),
                  const VerifyCodeButton(),
                  VerticalSpace(height: AppHeight.h24),
                  const ResendCodeText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
