import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/room_model.dart';
import 'package:meta/meta.dart';

abstract class RoomState extends Equatable {}

class RoomInitState extends RoomState {
  @override
  List<Object> get props => [];
}

class RoomLoading extends RoomState {
  @override
  List<Object> get props => [];
}

class RoomLoaded extends RoomState {
  final List<RoomModel> rooms;

  RoomLoaded({@required this.rooms});

  @override
  List<Object> get props => [rooms];
}

class RoomLoadFailure extends RoomState {
  final String error;

  RoomLoadFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
