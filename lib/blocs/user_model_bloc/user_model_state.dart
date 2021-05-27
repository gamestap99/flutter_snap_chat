import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

class UserModelState extends Equatable {
  final UserModel userModel;

  UserModelState({this.userModel});

  factory UserModelState.initial() => UserModelState(
        userModel: UserModel.empty,
      );

  UserModelState copyWith({
    userModel,
  }) =>
      UserModelState(
        userModel: userModel ?? this.userModel,
      );

  @override
  // TODO: implement props
  List<Object> get props => [userModel];
}
