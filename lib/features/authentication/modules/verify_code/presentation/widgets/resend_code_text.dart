import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_cubit.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_state.dart';
import 'package:tabibi/features/authentication/modules/widgets/auth_prompt_text.dart';

class ResendCodeText extends StatelessWidget {
  const ResendCodeText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
      buildWhen: (previous, current) =>
          previous.resendStatus != current.resendStatus,
      builder: (context, state) {
        final cubit = context.read<VerifyCodeCubit>();
        return AuthPromptText(
          gestureDetectorName: state.resendStatus == ResendCodeStatus.loading
              ? 'Sending...'
              : AppStrings.resend,
          text: AppStrings.didntGetCode,
          onPress: state.resendStatus == ResendCodeStatus.loading
              ? () {}
              : () => cubit.resendCode(),
        );
      },
    );
  }
}
