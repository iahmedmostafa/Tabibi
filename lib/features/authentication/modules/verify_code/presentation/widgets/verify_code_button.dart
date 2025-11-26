import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:tabibi/core/widgets/primary_button.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_cubit.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_state.dart';

class VerifyCodeButton extends StatelessWidget {
  const VerifyCodeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.origin != current.origin,
      builder: (context, state) {
        final cubit = context.read<VerifyCodeCubit>();
        return PrimaryButton(
          onPress: state.status == VerifyCodeStatus.loading
              ? null
              : () => cubit.submit(),
          title: state.status == VerifyCodeStatus.loading
              ? 'Verifying...'
              : (state.origin == VerifyOrigin.signup
                    ? AppStrings.activateAccount
                    : AppStrings.verify),
        );
      },
    );
  }
}
