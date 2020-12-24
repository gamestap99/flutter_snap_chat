import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_state.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';

class UserProviderCubit extends Cubit<UserProviderState> {
  UserProviderCubit(this._friendRepository) : super(UserProviderState());
  final FriendRepository _friendRepository;

  Future<void> getUser(String uid) async {
    try {
      final data = await _friendRepository.getUser(uid);
      emit(UserProviderState(userModel: data));
      print("userprovider:   ");
    } catch (ex) {
      throw Exception('Get user thất bại');
    }
  }
}
