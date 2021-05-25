

import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/blocs/add_search_name_bloc/add_search_name_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';
import 'package:flutter_snap_chat/screen_display/group_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uid = context.select((FriendProviderCubit bloc) => bloc.state.userModel.id.toString());
    return BlocProvider(
      create: (_) => AddSearchNameBloc(ApiFriendRepository(), uid),
      child: GroupScreen(),
    );
  }
}
