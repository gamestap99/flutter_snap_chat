import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/constant/app_color.dart';
import 'package:flutter_snap_chat/router.dart';
import 'package:flutter_snap_chat/screen_display/settings.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select((FriendProviderCubit bloc) => bloc.state.userModel);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tôi",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            user.avatar != null
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
                      imageUrl: user.avatar,
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
            SizedBox(
              height: 5,
            ),
            Text(
              user.name.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Card(
              elevation: 0.1,
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                    return ChatSettings();
                  }));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text('Thiết lập thông tin'),
                      ),
                      Icon(Icons.settings),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 0.1,
              child: MaterialButton(
                onPressed: () {
                  FirebaseFirestore.instance.collection('users').doc(user.id).update({
                    'status': "1",
                  });
                  context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
                  Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.init, (route) => false);

                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text('Đăng xuất'),
                      ),
                      Icon(Icons.exit_to_app),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
