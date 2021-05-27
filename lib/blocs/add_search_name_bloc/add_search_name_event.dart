import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/contact_model.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

abstract class AddSearchNameEvent extends Equatable {}

class AddSeachNameGetData extends AddSearchNameEvent {
  final List<ContactModel> contacts;

  AddSeachNameGetData(this.contacts);

  @override
  // TODO: implement props
  List<Object> get props => [contacts];
}

class AddGroup extends AddSearchNameEvent {
  final List<UserModel> users;
  final String name;

  AddGroup(this.users, this.name);

  @override
  // TODO: implement props
  List<Object> get props => [users, name];
}
