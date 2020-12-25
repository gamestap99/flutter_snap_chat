import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/count_request_friend_bloc/count_request_friend_bloc.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';
import 'package:flutter_snap_chat/screen_display/control_screen.dart';

class ControlContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uid = context.select((AuthenticationBloc bloc) => bloc.state.user.id.toString());
    print(uid + "uid:  " +uid);
    Map<String,dynamic> argument= ModalRoute.of(context).settings.arguments;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CountRequestFriendBloc(ApiFriendRepository(), uid),
        ),
        BlocProvider(
          create: (_)=>UserProviderCubit(ApiFriendRepository())..getUser(argument["userId"]),
        )
      ],
      child: ControlScreen(),
    );
  }
}
