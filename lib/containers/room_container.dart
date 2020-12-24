import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/chat_bloc/chat_cubit.dart';
import 'package:flutter_snap_chat/repositories/chat_repository.dart';
import 'package:flutter_snap_chat/screen_display/chat_display_screen.dart';
import 'package:flutter_snap_chat/widget/bottom_navigate.dart';

class ChatContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    print(args["userId"].toString());
    return BlocProvider(
      create: (_) => ChatCubit(repository: ApiRoomRepository(), uid: args["userId"].toString()),
      child: ChatDisplayScreen(),
    );
  }
}
