import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabibi/features/authentication/domain/usecases/log_in_use_case.dart';
import '../../../../data/models/log_in_request_params_model.dart';
import '../../../../domain/entities/log_in_entity.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tabibi/core/services/cache_helper.dart';
import 'dart:developer';
part 'log_in_state.dart';

class LogInCubit extends Cubit<LogInState> {
  LogInCubit(this.logInUseCase) : super(LogInInitial());
  final LogInUseCase logInUseCase;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void logIn() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    emit(LogInLoading());
    final result = await logInUseCase(
      LogInRequestParamsModel(
        email: emailController.text,
        password: passwordController.text,
      ),
    );
    result.fold((l) => emit(LogInFailure(errorMessage: l.message)), (r) async {
      String? role;
      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(r.accessToken);
        // Check for common role claim names
        var rawRole =
            decodedToken['role']?.toString() ??
            decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']
                ?.toString();

        if (rawRole == 'Doctor') {
          role = '2';
        } else if (rawRole == 'Patient') {
          role = '1';
        } else {
          role = rawRole;
        }
      } catch (e) {
        log('Error decoding token: $e');
      }

      if (role == null) {
        role = await CacheHelper.getData(key: 'role');
      }

      emit(LogInSuccess(logInEntity: r, role: role));
    });
  }
}
