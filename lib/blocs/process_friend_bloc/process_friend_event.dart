import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/contact_model.dart';

abstract class ProcessFriendEvent extends Equatable {}

class ProcessFriendDataChanged extends ProcessFriendEvent {
  final List<ContactModel> contacts;

  ProcessFriendDataChanged(this.contacts);

  @override
  // TODO: implement props
  List<Object> get props => [contacts];
}
