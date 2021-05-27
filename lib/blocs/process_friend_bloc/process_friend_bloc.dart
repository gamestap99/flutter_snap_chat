import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/process_friend_bloc/process_friend_event.dart';
import 'package:flutter_snap_chat/blocs/process_friend_bloc/process_friend_state.dart';
import 'package:flutter_snap_chat/models/contact_model.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';

class ProcessFriendBloc extends Bloc<ProcessFriendEvent, ProcessFriendState> {
  ProcessFriendBloc(this._friendRepository, this.uid) : super(ProcessFriendLoading()) {
    _subcription = _friendRepository.getAllApectContact(uid).listen((event) {
      add(ProcessFriendDataChanged(event));
    });
  }

  final FriendRepository _friendRepository;
  final String uid;
  StreamSubscription<List<ContactModel>> _subcription;

  @override
  Stream<ProcessFriendState> mapEventToState(ProcessFriendEvent event) async* {
    try {
      if (event is ProcessFriendDataChanged) {
        if (event.contacts.length > 0) {
          List<String> uids = [];
          event.contacts.forEach((element) {
            uids.add(element.senderId);
          });
          final users = await _friendRepository.getUsers(uids);

          yield ProcessFriendLoaded(users: users, contacts: event.contacts);
        } else {
          yield ProcessFriendLoaded(users: [], contacts: event.contacts);
        }
      }
    } catch (ex) {
      yield ProcessFriendLoadFailure(ex.toString());
    }
  }

  @override
  Future<void> close() {
    _subcription?.cancel();
    return super.close();
  }
}
