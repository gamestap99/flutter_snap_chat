import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/count_request_friend_bloc/count_request_friend_bloc.dart';
import 'package:flutter_snap_chat/blocs/update_status_bloc/update_status_cubit.dart';
import 'package:flutter_snap_chat/blocs/update_status_bloc/update_status_state.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';
import 'package:flutter_snap_chat/screen_display/control_screen.dart';

class ControlContainer extends StatefulWidget {
  @override
  _ControlContainerState createState() => _ControlContainerState();
}

class _ControlContainerState extends State<ControlContainer> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String uid = context.select((AuthenticationBloc bloc) => bloc.state.user.id.toString());

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CountRequestFriendBloc(ApiFriendRepository(), uid),
        ),
        BlocProvider(
          create: (_)=>UpdateStatusCubit(UpdateStatusState())..updateStatus(uid),
        )
        // BlocProvider.value(
        //   value: context.select((value) => null)<UserProviderCubit>()..getUser(uid),
        // ),
      ],
      child: ControlScreen(),
    );
  }
}
