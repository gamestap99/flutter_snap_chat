import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/friend_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';
import 'package:flutter_snap_chat/screen_display/friend_display_screen.dart';

class FriendContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uid = context.select((UserProviderCubit bloc) => bloc.state.userModel.id.toString());
    return BlocProvider(
      create: (_) => FriendBloc(friendRepository: ApiFriendRepository(), uid:uid),
      child: FriendDisplayScreen(),
    );
  }
}
