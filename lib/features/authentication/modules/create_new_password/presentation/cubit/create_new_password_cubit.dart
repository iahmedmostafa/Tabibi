import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tabibi/features/authentication/domain/usecases/create_new_password_use_case.dart'; // IMPORT NEW USE CASE
import 'package:tabibi/features/authentication/modules/create_new_password/presentation/cubit/create_new_password_state.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  final CreateNewPasswordUseCase createNewPasswordUseCase; // تغيير الاسم

  CreateNewPasswordCubit(this.createNewPasswordUseCase)
      : super(const CreateNewPasswordState());

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void setTargetEmail(String email) {
    emit(state.copyWith(targetEmail: email));
  }

  void createNewPassword() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (state.targetEmail.isEmpty) {
      emit(state.copyWith(
        status: CreatePasswordStatus.failure,
        errorMessage: 'Email not provided for password creation.',
      ));
      return;
    }

    emit(state.copyWith(status: CreatePasswordStatus.loading));


    final resetData = CreateNewPasswordParameters(
      email: state.targetEmail,
      newPassword: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    final result = await createNewPasswordUseCase(resetData);

    log('Create New Password Result: ${result.toString()}');

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: CreatePasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
          (message) => emit(
        state.copyWith(
          status: CreatePasswordStatus.success,
          message: message,
        ),
      ),
    );
  }
}