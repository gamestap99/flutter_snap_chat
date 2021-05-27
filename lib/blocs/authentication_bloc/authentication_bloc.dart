import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/authentication_event.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/authentication_state.dart';
import 'package:flutter_snap_chat/repositories/user_firebase.dart';
import 'package:flutter_snap_chat/repositories/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AuthenticationUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<UserFirebase> _userSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      yield _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      unawaited(_authenticationRepository.logOut());
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  AuthenticationState _mapAuthenticationUserChangedToState(
    AuthenticationUserChanged event,
  ) {
    return event.user != UserFirebase.empty ? AuthenticationState.authenticated(event.user) : const AuthenticationState.unauthenticated();
  }
}
