import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';

import 'package:flutter_snap_chat/blocs/room_bloc/room_bloc.dart';
import 'package:flutter_snap_chat/repositories/room_repository.dart';
import 'package:flutter_snap_chat/screen_display/room_display_screen.dart';


class RoomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uid = context.select((AuthenticationBloc bloc) => bloc.state.user.id.toString());

    Map<String, dynamic> argument = ModalRoute.of(context).settings.arguments;

    return BlocProvider(
      create: (_) => RoomBloc(ApiRoomRepository(), uid),
      child: RoomDisplayScreen(uid: uid,),
    );
  }
}
