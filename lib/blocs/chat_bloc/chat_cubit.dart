import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/chat_bloc/bloc.dart';
import 'package:flutter_snap_chat/repositories/chat_repository.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';
import 'package:meta/meta.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;
  final FriendRepository friendRepository;

  ChatCubit({
    @required this.repository,
    @required this.friendRepository,
  }) : super(ChatLoading());

  // Future<void> getMessages(String  roomId) async {
  //   try{
  //     final messages =await repository.getMessages(roomId);
  //     emit(ChatLoaded(messages: messages));
  //   }catch (e){
  //     emit(ChatLoadFailue(error: e));
  //   }
  // }
  Future<void> getUser(List<String> member, String uid) async {
    try {
      print("member:" + member.length.toString());
      final data = await friendRepository.getUsers(member);
      emit(ChatLoaded(users: data));
    } catch (ex) {
      print("errorr: " + ex.toString());
      emit(ChatLoadFailue(error: ex.toString()));
    }
  }
}
