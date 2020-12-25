import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.control, (route) => false, arguments: {
              "userId": state.user.id,
            });
            // context.read<UserProviderCubit>().getUser(state.user.id).then((value) => );

            break;
          default:
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("get data firebase"),
        ),
      ),
    );
  }
}
