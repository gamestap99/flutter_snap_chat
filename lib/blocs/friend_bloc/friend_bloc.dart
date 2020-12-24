import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/friend_bloc/bloc.dart';
import 'package:flutter_snap_chat/models/contact_model.dart';
import 'package:flutter_snap_chat/models/friend_model.dart';
import 'package:flutter_snap_chat/models/user_model.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  final String uid;

  FriendBloc({@required FriendRepository friendRepository, @required this.uid})
      : assert(friendRepository != null),
        _friendRepository = friendRepository,
        super(FriendLoading()) {
    _streamSubscription = _friendRepository.friends(uid).listen((event) {
      add(FriendDataChange(event));
    });
  }

  final FriendRepository _friendRepository;
  StreamSubscription<List<ContactModel>> _streamSubscription;

  @override
  Stream<FriendState> mapEventToState(FriendEvent event) async* {
    // TODO: implement mapEventToState
    if (event is FriendDataChange) {
      yield* _mapAuthenticationUserChangedToState(event);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  Stream<FriendState> _mapAuthenticationUserChangedToState(
    FriendDataChange event,
  ) async* {
    try{
      if(event.contacts.length > 0 ){
        List<String> users= _friendRepository.getIdFriends(event.contacts,uid);
        final count =await _friendRepository.getCountAcpectFriend(uid);
        yield FriendLoaed(users,count);
      }else{
        yield FriendLoadFail();
      }
    }catch(e){
      yield FriendLoadFail();
    }
  }
}
