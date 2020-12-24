import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'file:///E:/btl%20di%20dong/btl_didong/flutter_snap_chat/lib/repositories/user_repository.dart';
import 'package:flutter_snap_chat/screen_display/init_screen.dart';

class InitContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthenticationBloc(authenticationRepository: AuthenticationRepository()),
      child: InitScreen()  ,
    );
  }
}
