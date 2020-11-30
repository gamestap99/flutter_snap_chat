import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/repositories/user_repository/user_repository.dart';
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
