import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tabibi/features/authentication/domain/usecases/forgot_password_use_case.dart';
import 'package:tabibi/features/authentication/modules/forgot_password/presentation/cubit/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this.forgotPasswordUseCase)
      : super(const ForgotPasswordState());

  final ForgotPasswordUseCase forgotPasswordUseCase;

  final emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void sendCode() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    final result = await forgotPasswordUseCase(
      ForgotPasswordParameters(email: emailController.text),
    );

    log(result.toString());

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
          (message) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.success,
          message: message,
        ),
      ),
    );
  }
}
