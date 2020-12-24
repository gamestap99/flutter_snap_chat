
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/sign_up_bloc/sign_up_cubit.dart';
import 'package:flutter_snap_chat/repositories/user_repository.dart';
import 'package:flutter_snap_chat/screen_display/items/sign_up_form.dart';


class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => SignUpCubit(AuthenticationRepository()),
          child: SignUpForm(),
        ),
      ),
    );
  }
}