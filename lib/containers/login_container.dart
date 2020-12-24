import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/login_bloc/login_cubit.dart';
import 'file:///E:/btl%20di%20dong/btl_didong/flutter_snap_chat/lib/screen_display/login.dart';
import 'file:///E:/btl%20di%20dong/btl_didong/flutter_snap_chat/lib/repositories/user_repository.dart';

class LoginContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
      child: LoginScreen(),
    );
  }
}

