import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_event.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_state.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';
import 'package:flutter_snap_chat/repositories/user_firebase.dart';
import 'package:flutter_snap_chat/repositories/user_repository.dart';

class UserProviderBloc extends Bloc<UserProviderEvent, UserProviderState> {
  UserProviderBloc(this._authenticationRepository, this._friendRepository) : super(UserProviderState()) {
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(UserProviderDataChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final FriendRepository _friendRepository;
  StreamSubscription<UserFirebase> _userSubscription;

  @override
  Stream<UserProviderState> mapEventToState(UserProviderEvent event) async* {
    // TODO: implement mapEventToState
    if (event is UserProviderDataChanged) {
      try {
        final data = await _friendRepository.getUser(event.user.id);
        yield state.copyWith(
          user: data,
          status: UserProviderStatus.success,
        );
      } catch (ex) {
        yield state.copyWith(
          status: UserProviderStatus.success,
        );
      }
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _userSubscription?.cancel();
    return super.close();
  }
}
