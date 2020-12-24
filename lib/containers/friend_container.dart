import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/friend_bloc/bloc.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';
import 'package:flutter_snap_chat/screen_display/friend_display_screen.dart';

class FriendContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    print(args["userId"].toString());
    return BlocProvider(
      create: (_) => FriendBloc(friendRepository: ApiFriendRepository(), uid: args["userId"].toString()),
      child: FriendDisplayScreen(),
    );
  }
}
