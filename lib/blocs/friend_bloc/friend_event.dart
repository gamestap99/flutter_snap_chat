
import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/contact_model.dart';
import 'package:flutter_snap_chat/models/friend_model.dart';

abstract class FriendEvent extends Equatable{

}
class FriendDataChange extends FriendEvent{
  final List<ContactModel> contacts;

  FriendDataChange(this.contacts);

  @override
  // TODO: implement props
  List<Object> get props => [contacts];

}
class FriendGetCountAcpect extends FriendEvent{
  final String count;

  FriendGetCountAcpect(this.count);
  @override
  // TODO: implement props
  List<Object> get props => [count];

}
