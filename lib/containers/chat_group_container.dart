import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/chat_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/chat_group_bloc/chat_group_cubit.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/models/room_model.dart';
import 'package:flutter_snap_chat/repositories/chat_repository.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';
import 'package:flutter_snap_chat/screen_display/chat_group_screen.dart';

class ChatGroupContainer extends StatelessWidget {
  final RoomModel roomModel;

  const ChatGroupContainer({Key key, @required this.roomModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String uid = context.select((AuthenticationBloc bloc) => bloc.state.user.id.toString());
    String userName = context.select((UserProviderCubit cubit) => cubit.state.userModel.name.toString());
    Map<String, dynamic> argument = ModalRoute.of(context).settings.arguments;
    return BlocProvider(
      create: (_) => ChatGroupCubit(
        repository: ApiChatRepository(),
        friendRepository: ApiFriendRepository(),
      )..getUser(roomModel.member, uid),
      child: ChatGroupScreen(
        roomModel: roomModel, uid: uid,
      ),
    );
  }
}
