import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/router.dart';

class InitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthenticationStatus.unauthenticated:
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            break;
          case AuthenticationStatus.authenticated:
            print("fsdfsdfds");
            context.read<UserProviderCubit>().getUser(state.user.id).then((value) => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.control, (route) => false, arguments: {
                  "userId": state.user.id,
                }));

            break;
          default:
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Get data firebase"),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
