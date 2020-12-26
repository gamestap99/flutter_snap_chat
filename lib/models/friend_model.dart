import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FriendModel extends Equatable {
  final Map<dynamic, dynamic> friends;

  const FriendModel({
    @required this.friends,
  });

  static const empty = FriendModel(friends: {});

  @override
  // TODO: implement props
  List<Object> get props => [friends];
}
