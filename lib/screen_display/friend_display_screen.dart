import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/count_request_friend_bloc/count_request_friend_bloc.dart';
import 'package:flutter_snap_chat/blocs/friend_bloc/bloc.dart';
import 'package:flutter_snap_chat/const.dart';
import 'package:flutter_snap_chat/containers/process_friend_container.dart';
import 'package:flutter_snap_chat/containers/profile_container.dart';
import 'package:flutter_snap_chat/models/user_model.dart';
import 'package:flutter_snap_chat/screen_display/profile_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FriendDisplayScreen extends StatefulWidget {
  @override
  _FriendDisplayScreenState createState() => _FriendDisplayScreenState();
}

class _FriendDisplayScreenState extends State<FriendDisplayScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String uid = context.select((AuthenticationBloc bloc) => bloc.state.user.id.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Bạn bè"),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                return ProcessFriendContainer();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.userPlus),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Lời mời kết bạn",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Text(
                    context.watch<CountRequestFriendBloc>().state.count.toString(),
                    style: TextStyle(color: Colors.red, fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 10,
            thickness: 1,
          ),
          BlocConsumer<FriendBloc, FriendState>(
              builder: (context, state) {
                if (state is FriendLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is FriendLoaed) {
                  return Column(
                    children: [
                      ListView.builder(
                          itemCount: state.friends.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance.collection('users').doc(state.friends[index]).snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Text("Loading");
                                  }
                                  return buildItem(context, snapshot.data, uid);
                                });
                          }),
                    ],
                  );
                }
                return Container(
                  child: Center(
                    child: Text('Chưa có bạn bè'),
                  ),
                );
              },
              listener: (context, state) {}),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot snapshot, String uid) {
    if (snapshot.id == uid) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Material(
                        child: snapshot.data()['photoUrl'] != null
                            ? CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                                  ),
                                  width: 50.0,
                                  height: 50.0,
                                  padding: EdgeInsets.all(15.0),
                                ),
                                imageUrl: snapshot.data()['photoUrl'],
                                width: 50.0,
                                height: 50.0,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.account_circle,
                                size: 50.0,
                                color: greyColor,
                              ),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 35,
                    left: 35,
                    child: snapshot.data()['status'].toString() == "0"
                        ? Icon(
                            Icons.circle,
                            color: Colors.green,
                          )
                        : Icon(Icons.circle),
                  )
                ],
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          snapshot.data()['nickname'],
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileContainer(
                          uid: uid,
                          peerUser: UserModel(
                            id: snapshot.id,
                            name: snapshot.data()['nickname'],
                            photo: snapshot.data()['photoUrl'],
                            fcmToken: snapshot.data()['pushToken'],
                            status: snapshot.data()['status'],
                          ),
                        )));
          },
          color: greyColor2,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }
}
