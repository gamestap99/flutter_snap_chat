import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/user_model_bloc/user_model_event.dart';
import 'package:flutter_snap_chat/blocs/user_model_bloc/user_model_state.dart';
import 'package:flutter_snap_chat/repositories/user_firebase.dart';
import 'package:flutter_snap_chat/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class UserModelBloc extends Bloc<UserModelEvent, UserModelState> {
  UserModelBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(UserModelState.initial()) {
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(UserModelChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<UserFirebase> _userSubscription;

  @override
  Stream<UserModelState> mapEventToState(
    UserModelEvent event,
  ) async* {
    if (event is UserModelChanged) {
      yield* _mapAuthenticationUserChangedToState(event);
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  Stream<UserModelState> _mapAuthenticationUserChangedToState(UserModelChanged event) async*{

    if(event.user != UserFirebase.empty){
     final data = await _authenticationRepository.getUserDetails();

     print("data----");
     print(data.toString());

      yield state.copyWith(
        userModel: data,
      );
    }


  }
}
