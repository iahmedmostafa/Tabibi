import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabibi/features/authentication/domain/usecases/log_in_use_case.dart';
import '../../../../data/models/log_in_request_params_model.dart';
import '../../../../domain/entities/log_in_entity.dart';
part 'log_in_state.dart';

class LogInCubit extends Cubit<LogInState> {
  LogInCubit(this.logInUseCase) : super(LogInInitial());
  final LogInUseCase logInUseCase;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void logIn() async {
      if(!(formKey.currentState?.validate()?? false)){
        return;
      }
    emit(LogInLoading());
    final result = await logInUseCase(
        LogInRequestParamsModel(
          email: emailController.text,
          password: passwordController.text,
        ),
      );
    result.fold(
          (l) => emit(
        LogInFailure(errorMessage: l.message),
      ),
          (r) => emit(LogInSuccess(logInEntity: r)),
    );

  }


}
