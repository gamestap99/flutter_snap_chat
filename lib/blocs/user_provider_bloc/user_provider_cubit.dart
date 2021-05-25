import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_state.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';

class FriendProviderCubit extends Cubit<UserProviderState> {
  FriendProviderCubit(this._friendRepository) : super(UserProviderState());
  final FriendRepository _friendRepository;

  Future<void> getUser(String uid) async {
    try {
      print("uidr:   " + uid);
      emit(
        state.copyWith(
          status: UserProviderStatus.loading,
        ),
      );
      final data = await _friendRepository.getUser(uid);
      emit(state.copyWith(
        user: data,
        status: UserProviderStatus.success,
      ));
      print("userprovider:   ");
    } catch (ex) {
      print("ex:" + ex.toString());
      throw Exception('Get user thất bại');
    }
  }
}
