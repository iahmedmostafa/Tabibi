import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tabibi/core/routing/app_routes.dart';
import 'package:tabibi/core/utils/helper/helper_functions.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_cubit.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_state.dart';
import 'package:easy_localization/easy_localization.dart';

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
                AppHelperFunctions.showAwesomeSnackBar(
                  title: 'success'.tr(),
                  message: state.message ?? 'verificationSuccessful'.tr(),
                  contentType: ContentType.success,
                  context: context,
                );
                context.goNamed(
                  AppRoutes.createNewPassword,
                  extra: context.read<VerifyCodeCubit>().state.targetEmail,
                );
              } else if (state.origin == VerifyOrigin.signup) {
                AppHelperFunctions.showAwesomeSnackBar(
                  title: 'success'.tr(),
                  message: 'accountCreatedSuccessfully'.tr(),
                  contentType: ContentType.success,
                  context: context,
                );
                context.go(AppRoutes.login);
              } else {
                AppHelperFunctions.showAwesomeSnackBar(
                  title: 'success'.tr(),
                  message: state.message ?? 'verificationSuccessful'.tr(),
                  contentType: ContentType.success,
                  context: context,
                );
              }
            } else if (state.status == VerifyCodeStatus.failure) {
              AppHelperFunctions.showAwesomeSnackBar(
                title: 'error'.tr(),
                message: state.errorMessage ?? 'verificationFailed'.tr(),
                contentType: ContentType.failure,
                context: context,
              );
            }
          },
        ),
        BlocListener<VerifyCodeCubit, VerifyCodeState>(
          listenWhen: (previous, current) =>
              previous.resendStatus != current.resendStatus,
          listener: (context, state) {
            if (state.resendStatus == ResendCodeStatus.success) {
              AppHelperFunctions.showAwesomeSnackBar(
                title: 'success'.tr(),
                message: state.message ?? 'codeResentSuccessfully'.tr(),
                contentType: ContentType.success,
                context: context,
              );
            } else if (state.resendStatus == ResendCodeStatus.failure) {
              AppHelperFunctions.showAwesomeSnackBar(
                title: 'error'.tr(),
                message: state.errorMessage ?? 'failedToResendCode'.tr(),
                contentType: ContentType.failure,
                context: context,
              );
            }
          },
        ),
      ],
      child: child,
    );
  }
}
