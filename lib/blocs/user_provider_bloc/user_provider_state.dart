

import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

class UserProviderState extends Equatable{
  final UserModel userModel;

  UserProviderState({this.userModel});

  @override
  // TODO: implement props
  List<Object> get props => [userModel];
}