
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_snap_chat/blocs/room_bloc/room_event.dart';
import 'package:flutter_snap_chat/blocs/room_bloc/room_state.dart';
import 'package:flutter_snap_chat/models/room_model.dart';
import 'package:flutter_snap_chat/repositories/room_repository.dart';

class RoomBloc extends Bloc<RoomEvent,RoomState>{
  RoomBloc(this._repository,this.uid) : super(RoomLoading()){
    _streamSubscription = _repository.getRoom(uid).listen((event) {
      add(RoomDataChanged(event));
    });
  }
  final String uid;
  final RoomRepository _repository;
  StreamSubscription<List<RoomModel>> _streamSubscription;
  @override
  Stream<RoomState> mapEventToState(RoomEvent event) async*{
    if(event is RoomDataChanged){
      if(event.rooms.length > 0){
        yield RoomLoaded(rooms: event.rooms);
      }else{
        yield RoomLoadFailure(error: "Hãy nhắn tin đi nào");
      }
    }
  }
  @override
  Future<void> close() {
    // TODO: implement close
    _streamSubscription?.cancel();
    return super.close();
  }
}