

import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

abstract class ContactState extends Equatable{

}

class ContactLoading extends ContactState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class ContactLoaded extends ContactState{
 final List<UserModel> users;

  ContactLoaded(this.users);

  @override
  // TODO: implement props
  List<Object> get props => [users];

}
class ContactLoadFail extends ContactState{
  final String error;

  ContactLoadFail(this.error);
  @override
  // TODO: implement props
  List<Object> get props => [error];

}