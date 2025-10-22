import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/enums/enums.dart';
import 'package:tabibi/features/authentication/domain/usecases/sign_up_use_case.dart';
import 'package:tabibi/features/authentication/modules/signup/presentation/cubit/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this.signUpUseCase) : super(const SignUpState());

  final SignUpUseCase signUpUseCase;
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void signUp() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    emit(state.copyWith(status: SignUpStatus.loading));
    final result = await signUpUseCase(
      SignUpParameters(
        email: emailController.text,
        firstName: nameController.text,
        lastName: 'fdgd',
        password: passwordController.text,
      ),
    );
    log(result.toString());
    result.fold(
      (l) => emit(
        state.copyWith(status: SignUpStatus.failure, errorMessage: l.message),
      ),
      (r) => emit(state.copyWith(status: SignUpStatus.success, message: r)),
    );
  }
}
