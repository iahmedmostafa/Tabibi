import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'create_new_password_state.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  CreateNewPasswordCubit() : super(CreateNewPasswordInitial());
}
