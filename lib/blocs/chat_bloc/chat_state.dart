import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/user_model.dart';
import 'package:meta/meta.dart';

abstract class ChatState extends Equatable {}

class ChatLoading extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ChatLoaded extends ChatState {
  final List<UserModel> users;

  ChatLoaded({
    @required this.users,
  });

  @override
  // TODO: implement props
  List<Object> get props => [users];
}

class ChatLoadFailue extends ChatState {
  final String error;

  ChatLoadFailue({@required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [];
}
