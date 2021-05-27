import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/room_model.dart';

abstract class RoomEvent extends Equatable {}

class RoomDataChanged extends RoomEvent {
  final List<RoomModel> rooms;

  RoomDataChanged(this.rooms);

  @override
  // TODO: implement props
  List<Object> get props => [rooms];
}
