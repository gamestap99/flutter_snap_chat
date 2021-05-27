
import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/repositories/user_firebase.dart';

abstract class UserModelEvent extends Equatable {
  const UserModelEvent();

  @override
  List<Object> get props => [];
}

class UserModelChanged extends UserModelEvent {
  const UserModelChanged(this.user);

  final UserFirebase user;

  @override
  List<Object> get props => [user];
}


