import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

enum UserProviderStatus { none, loading, success, error }

class UserProviderState extends Equatable {
  final UserProviderStatus status;
  final UserModel userModel;

  UserProviderState({
    this.userModel = UserModel.empty,
    this.status = UserProviderStatus.none,
  });

  UserProviderState copyWith({
    user,
    status,
  }) {
    return UserProviderState(
      userModel: user ?? this.userModel,
      status: status ?? this.status,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [userModel,status];
}
