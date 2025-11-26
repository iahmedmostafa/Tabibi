import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_cubit.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_state.dart';

class VerifyCodeListeners extends StatelessWidget {
  final Widget child;

  const VerifyCodeListeners({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<VerifyCodeCubit, VerifyCodeState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == VerifyCodeStatus.success) {
              if (state.origin == VerifyOrigin.forgot) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message ?? 'Verification successful!'),
                  ),
                );
                context.goNamed(
                  AppRoutes.createNewPassword,
                  extra: context.read<VerifyCodeCubit>().state.targetEmail,
                );
              } else if (state.origin == VerifyOrigin.signup) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Done successfully')),
                );
                context.go(AppRoutes.home);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message ?? 'Verification successful!'),
                  ),
                );
              }
            } else if (state.status == VerifyCodeStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Verification failed!'),
                ),
              );
            }
          },
        ),
        BlocListener<VerifyCodeCubit, VerifyCodeState>(
          listenWhen: (previous, current) =>
              previous.resendStatus != current.resendStatus,
          listener: (context, state) {
            if (state.resendStatus == ResendCodeStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Code resent successfully!'),
                ),
              );
            } else if (state.resendStatus == ResendCodeStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Failed to resend code!'),
                ),
              );
            }
          },
        ),
      ],
      child: child,
    );
  }
}
