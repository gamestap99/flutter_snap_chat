import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/contact_model.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

abstract class ProcessFriendState extends Equatable {}

class ProcessFriendLoading extends ProcessFriendState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ProcessFriendLoaded extends ProcessFriendState {
  final List<UserModel> users;
  final List<ContactModel> contacts;

  ProcessFriendLoaded({this.users, this.contacts});

  @override
  // TODO: implement props
  List<Object> get props => [users, contacts];
}

class ProcessFriendLoadFailure extends ProcessFriendState {
  final String error;

  ProcessFriendLoadFailure(this.error);

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
