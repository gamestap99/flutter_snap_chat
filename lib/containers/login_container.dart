import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/login_bloc/login_cubit.dart';
import 'package:flutter_snap_chat/repositories/user_repository.dart';
import 'package:flutter_snap_chat/screen_display/login.dart';

class LoginContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
      child: LoginScreen(),
    );
  }
}
