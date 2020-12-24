import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/const.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/router.dart';


class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select((UserProviderCubit bloc) => bloc.state.userModel);
    return Scaffold(
      appBar: AppBar(
        title: Text("Tôi"),
      ),
      body: Center(
        child: Column(
          children: [
            user.photo != null
                ? Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                        ),
                        width: 150.0,
                        height: 150.0,
                        padding: EdgeInsets.all(20.0),
                      ),
                      imageUrl: user.photo,
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    clipBehavior: Clip.hardEdge,
                  )
                : Icon(
                    Icons.account_circle,
                    size: 150.0,
                    color: greyColor,
                  ),
            Text(user.name.toString()),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.init, (route) => false);
                context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
              },
              child: Container(
                width: double.infinity,
                child: Text('Đăng xuất'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
