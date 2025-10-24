import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tabibi/features/authentication/domain/usecases/forgot_password_use_case.dart';
import 'package:tabibi/features/authentication/domain/usecases/verify_code_use_case.dart';
import 'package:tabibi/features/authentication/modules/verify_code/presentation/cubit/verify_code_state.dart';

class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  final VerifyCodeUseCase verifyCodeUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  VerifyCodeCubit(this.verifyCodeUseCase, this.forgotPasswordUseCase)
      : super(const VerifyCodeState());

  final TextEditingController pinController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void setTargetEmail(String email) {
    emit(state.copyWith(targetEmail: email));
  }

  void verifyCode() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
 //edit ----> loading
    emit(state.copyWith(status: VerifyCodeStatus.success));

    final result = await verifyCodeUseCase(
      VerifyCodeParameters(
        email: state.targetEmail,
        code: pinController.text,
      ),
    );

    log('Verify Result: ${result.toString()}');

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: VerifyCodeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
          (message) => emit(
        state.copyWith(
          status: VerifyCodeStatus.success,
          message: message,
        ),
      ),
    );
  }

  void resendCode() async {
    emit(state.copyWith(resendStatus: ResendCodeStatus.loading));

    final result = await forgotPasswordUseCase(
      ForgotPasswordParameters(email: state.targetEmail),
    );

    log('Resend Result: ${result.toString()}');

    result.fold(
          (failure) => emit(
        state.copyWith(
          resendStatus: ResendCodeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
          (message) => emit(
        state.copyWith(
          resendStatus: ResendCodeStatus.success,
          message: message,
        ),
      ),
    );
  }
}