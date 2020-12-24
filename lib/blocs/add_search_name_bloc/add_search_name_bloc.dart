import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/add_search_name_bloc/add_search_name_event.dart';
import 'package:flutter_snap_chat/blocs/add_search_name_bloc/add_search_name_state.dart';
import 'package:flutter_snap_chat/models/contact_model.dart';
import 'package:flutter_snap_chat/models/friend_model.dart';
import 'package:flutter_snap_chat/models/user_model.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';

class AddSearchNameBloc extends Bloc<AddSearchNameEvent, AddSearchNameState> {
  AddSearchNameBloc(this._friendRepository, this.uid)
      : assert(_friendRepository != null),
        assert(uid != null),
        super(AddSearchNameLoading()) {
    _streamSubscription = _friendRepository.friends(uid).listen((event) {
      add(AddSeachNameGetData(event));
    });
  }

  final FriendRepository _friendRepository;
  final String uid;
  StreamSubscription<List<ContactModel>> _streamSubscription;

  @override
  Stream<AddSearchNameState> mapEventToState(AddSearchNameEvent event) async* {
    // TODO: implement mapEventToState
    if (event is AddSeachNameGetData) {
      yield* _mapGetFriend(event);
    }
  }

  Stream<AddSearchNameState> _mapGetFriend(AddSeachNameGetData event) async*{
    try{
     if(event.contacts.length > 0 ){
       final data = _friendRepository.getIdFriends(event.contacts,uid);
       final users =await _friendRepository.getUsers(data);
       yield AddSearchNameLoaded(users);

     }
    }catch(ex){
      yield AddSearchNameLoadFailure(ex.toString());
    }
  }
  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
