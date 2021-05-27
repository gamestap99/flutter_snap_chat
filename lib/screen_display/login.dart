import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_snap_chat/blocs/login_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/router.dart';
import 'package:flutter_snap_chat/screen_display/sign_up_page.dart';
import 'package:formz/formz.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Đăng Nhập"),
      // ),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            _onShowDialog(context, state.errorMessage);
          } else if (state.status.isSubmissionSuccess) {
            context.read<FriendProviderCubit>().getUser(context.read<AuthenticationBloc>().state.user.id);
            Navigator.of(context).popAndPushNamed(AppRoutes.control);
          }
        },
        child: Align(
          alignment: const Alignment(0, -1 / 3),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/bloc_logo_small.png',
                  height: 120,
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: _EmailInput(),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: _PasswordInput(),
                ),
                const SizedBox(height: 8.0),
                _LoginButton(),
                // const SizedBox(height: 8.0),
                // _GoogleLoginButton(),
                const SizedBox(height: 4.0),
                _SignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onShowDialog(BuildContext context, String message) {
    Widget okButton = FlatButton(
      child: Text("Thử lại"),
      onPressed: () => Navigator.pop(context),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Thông báo"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            helperText: '',
            errorText: state.email.invalid ? 'Email không hợp lệ' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) => context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mật khẩu',
            helperText: '',
            // errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : RaisedButton(
                key: const Key('loginForm_continue_raisedButton'),
                child: const Text('Đăng nhập'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: const Color(0xFFFFD600),
                onPressed: state.status.isValidated ? () => context.read<LoginCubit>().logInWithCredentials() : null,
              );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      child: Text(
        'Bạn chưa có tài khoản? Đăng ký!',
        style: TextStyle(color: theme.primaryColor),
      ),
      onTap: () {
        print("object");
        Navigator.of(context).push(CupertinoPageRoute(builder: (_) => SignUpPage()));
      },
    );
  }
}
