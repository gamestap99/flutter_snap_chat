import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/login_bloc/login_state.dart';
import 'package:flutter_snap_chat/helper/handle_error.dart';
import 'package:flutter_snap_chat/repositories/user_repository.dart';
import 'package:flutter_snap_chat/validators/validators.dart';
import 'package:formz/formz.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const LoginState());
  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }

  Future<void> logInWithCredentials() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      var result = await _authenticationRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      if (result) {
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      }
    } catch (ex) {
      // print("exception:");
      // print(ex.toString());
      // print(ex.code);
      emit(state.copyWith(
        errorMessage: HandleError.authError(ex.code),
        status: FormzStatus.submissionFailure,
      ));
    }
  }

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.logInWithGoogle();
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    } on NoSuchMethodError {
      emit(state.copyWith(status: FormzStatus.pure));
    }
  }
}
