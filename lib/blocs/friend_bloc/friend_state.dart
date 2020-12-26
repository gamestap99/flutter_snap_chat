
import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/friend_model.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

abstract class FriendState extends Equatable{

}
class FriendLoading extends FriendState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class FriendLoaed extends FriendState{
  final List<String> friends;
  final String countAcpect;
  FriendLoaed(this.friends,{this.countAcpect});
  @override
  // TODO: implement props
  List<Object> get props => [friends,countAcpect];
}
class FriendLoadFail extends FriendState{

  @override
  // TODO: implement props
  List<Object> get props => [];

}