import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

class RoomModel extends Equatable {
  const RoomModel({
    @required this.id,
    @required this.name,
    @required this.message,
    @required this.photo,
    @required this.type,
    @required this.member,
    @required this.createdAt,
    this.userModel,
  })  : assert(id != null),
        assert(name != null),
        assert(message != null),
        assert(type != null),
        assert(member != null);

  final String name;
  final String id;
  final String photo;
  final String message;
  final String type;
  final List<String> member;
  final UserModel userModel;
  final String createdAt;

  @override
  // TODO: implement props
  List<Object> get props => [id,name,photo,message,type,member,userModel,createdAt];
}
