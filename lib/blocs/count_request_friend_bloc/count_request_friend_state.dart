import 'package:equatable/equatable.dart';

class CountRequestFriendState extends Equatable {
  final int count;

  CountRequestFriendState({this.count = 0});

  @override
  // TODO: implement props
  List<Object> get props => [count];
}
