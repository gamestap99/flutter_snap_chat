import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/chat_bloc/bloc.dart';
import 'package:flutter_snap_chat/chat.dart';
import 'package:flutter_snap_chat/repositories/chat_repository.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';

class ChatContainer extends StatelessWidget {
  final List<String> member;
  final String roomId;
  final String peerId;
  final String peerAvatar;
  final String perToken;
  final String peerName;

  const ChatContainer({Key key, @required this.perToken, @required this.member, @required this.roomId, @required this.peerId, @required this.peerAvatar,@required this.peerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String uid = context.select((AuthenticationBloc bloc) => bloc.state.user.id.toString());
    return BlocProvider(
      create: (_) =>
      ChatCubit(repository: ApiChatRepository(), roomId: null, friendRepository: ApiFriendRepository())
        ..getUser(member, uid),
      child: Chat(
        peerId: peerId,
        peerAvatar: peerAvatar,
        roomID: roomId,
        members: member,
        perToken: perToken,
        name
        :peerName,
      ),
    );
  }
}
