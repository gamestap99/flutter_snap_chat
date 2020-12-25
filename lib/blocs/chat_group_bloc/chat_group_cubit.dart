

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/chat_group_bloc/chat_group_state.dart';
import 'package:flutter_snap_chat/repositories/chat_repository.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';
import 'package:meta/meta.dart';

class ChatGroupCubit extends Cubit<ChatGroupState>{
  final ChatRepository repository;
  final FriendRepository friendRepository;
  ChatGroupCubit({
    @required this.repository,
    @required this.friendRepository,
  }) : super(ChatGroupLoading());

  // Future<void> getMessages(String  roomId) async {
  //   try{
  //     final messages =await repository.getMessages(roomId);
  //     emit(ChatLoaded(messages: messages));
  //   }catch (e){
  //     emit(ChatLoadFailue(error: e));
  //   }
  // }
  Future<void> getUser(List<String> member,String uid) async {
    try{
      print("member:" + member.length.toString());
      final data = await friendRepository.getUsers(member);
      emit(ChatGroupLoaded(users: data));
    }catch(ex){
      print("errorr: "+ex.toString());
      emit(ChatGroupFailue(error: ex.toString()));
    }
  }

}