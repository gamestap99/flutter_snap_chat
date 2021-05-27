import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/count_request_friend_bloc/count_request_friend_event.dart';
import 'package:flutter_snap_chat/blocs/count_request_friend_bloc/count_request_friend_state.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';

class CountRequestFriendBloc extends Bloc<CountRequestFriendEvent, CountRequestFriendState> {
  CountRequestFriendBloc(this._friendRepository, this.uid) : super(CountRequestFriendState()) {
    _streamSubscription = _friendRepository.getCountAcpectFriend(uid).listen((event) {
      add(CountRequestFriendDataChange(event));
    });
  }

  final String uid;
  final FriendRepository _friendRepository;
  StreamSubscription<int> _streamSubscription;

  @override
  Stream<CountRequestFriendState> mapEventToState(CountRequestFriendEvent event) async* {
    if (event is CountRequestFriendDataChange) {
      yield CountRequestFriendState(count: event.count);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    // TODO: implement close
    return super.close();
  }
}
