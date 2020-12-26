
import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/user_model.dart';
import 'package:flutter_snap_chat/repositories/user_firebase.dart';


abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationUserChanged extends AuthenticationEvent {
  const AuthenticationUserChanged(this.user);

  final UserFirebase user;

  @override
  List<Object> get props => [user];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}