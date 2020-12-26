import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/process_friend_bloc/process_friend_bloc.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';
import 'package:flutter_snap_chat/screen_display/process_friend_screen.dart';

class ProcessFriendContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uid = context.select((AuthenticationBloc bloc) => bloc.state.user.id.toString());
    return BlocProvider(
      create: (_) => ProcessFriendBloc(ApiFriendRepository(), uid),
      child: ProcessFriendScreen(),
    );
  }
}
