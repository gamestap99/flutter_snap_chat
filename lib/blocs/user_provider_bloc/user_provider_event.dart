import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/repositories/user_firebase.dart';

abstract class UserProviderEvent extends Equatable {}

class UserProviderDataChanged extends UserProviderEvent {
  UserProviderDataChanged(this.user);

  final UserFirebase user;

  @override
  // TODO: implement props
  List<Object> get props => [user];
}
