import 'package:equatable/equatable.dart';

abstract class CountRequestFriendEvent extends Equatable {}

class CountRequestFriendDataChange extends CountRequestFriendEvent {
  final int count;

  CountRequestFriendDataChange(this.count);

  @override
  // TODO: implement props
  List<Object> get props => [count];
}
