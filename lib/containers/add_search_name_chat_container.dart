import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/add_search_name_bloc/add_search_name_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/friend_bloc/bloc.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';

import 'package:flutter_snap_chat/screen_display/add_search_name_screen.dart';

class AddSearchNameChatContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uid = context.select((AuthenticationBloc bloc) => bloc.state.user.id.toString());
    return BlocProvider(
      create: (_) => AddSearchNameBloc(ApiFriendRepository(), uid),
      child: AddSearchNameScreen(),
    );
  }
}
