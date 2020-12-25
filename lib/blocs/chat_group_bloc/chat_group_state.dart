import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/user_model.dart';
import 'package:meta/meta.dart';

abstract class ChatGroupState extends Equatable {}

class ChatGroupLoading extends ChatGroupState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ChatGroupLoaded extends ChatGroupState {
  final List<UserModel> users;

  ChatGroupLoaded({
    @required this.users,
  });

  @override
  // TODO: implement props
  List<Object> get props => [users];
}

class ChatGroupFailue extends ChatGroupState {
  final String error;

  ChatGroupFailue({@required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [];
}
