import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/repositories/user_firebase.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = UserFirebase.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(UserFirebase user) : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated() : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final UserFirebase user;

  @override
  List<Object> get props => [status, user];
}
