import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/room_bloc/room_bloc.dart';
import 'package:flutter_snap_chat/blocs/room_bloc/room_state.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/config/app.dart';
import 'package:flutter_snap_chat/const.dart';
import 'package:flutter_snap_chat/containers/add_search_name_chat_container.dart';
import 'package:flutter_snap_chat/router.dart';
import 'package:flutter_snap_chat/screen_display/items/chat_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoomDisplayScreen extends StatefulWidget {
  final String uid;

  const RoomDisplayScreen({Key key, @required this.uid}) : super(key: key);

  @override
  _RoomDisplayScreenState createState() => _RoomDisplayScreenState();
}

class _RoomDisplayScreenState extends State<RoomDisplayScreen> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registerNotification();
    configLocalNotification();

    // FirebaseAuth.instance.idTokenChanges().listen((firebaseUser) async {
    //   if(firebaseUser != null){
    //     // Get JWT from Firebase
    //     String token = await firebaseUser.getIdToken();
    //     print('test:'+token.toString());
    //     if(token != null){
    //       //Call ConnectyCube Flutter SDK method for auth via phone number
    //       signInUsingFirebase(App.Firebase_AppId, token).then((cubeUser) {
    //         print('test:'+cubeUser.toString());
    //       }).catchError((onError){
    //
    //       });
    //     }
    //   }
    // });
  }

  Future<void> _onCallAccepted(String sessionId, int callType, int callerId,
      String callerName, Set<int> opponentsIds) async {
    // onCallAccepted.call(sessionId);
  }

  Future<void> _onCallRejected(String sessionId, int callType, int callerId,
      String callerName, Set<int> opponentsIds) async {
    // onCallEnded.call(sessionId);
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      ConnectycubeFlutterCallKit.instance.init(
        onCallAccepted: _onCallAccepted,
        onCallRejected: _onCallRejected,
      );

      ConnectycubeFlutterCallKit.setOnLockScreenVisibility(
        isVisible: true,
      );

      ConnectycubeFlutterCallKit.showCallNotification(
        sessionId: "1111",
        callType: 0,
        callerName: "test",
        callerId: 0,
        opponentsIds: Set<int>.from({1, 2, 3}),
      );

      // AssetsAudioPlayer().open(Audio("assets/audios/call.mp3"),autoStart: true);
      // Platform.isAndroid ? showNotification(message['notification']) : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .update({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
    print(message['body'].toString());
    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

    // await flutterLocalNotificationsPlugin.show(0, 'plain title', 'plain body', platformChannelSpecifics, payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {
    String uid = context
        .select((AuthenticationBloc bloc) => bloc.state.user.id.toString());
    String image = context
        .select((FriendProviderCubit bloc) => bloc.state.userModel.photo);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent[500],
        title: Row(
          children: [
            MaterialButton(
              child: Material(
                child: image != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(themeColor),
                          ),
                          width: 50.0,
                          height: 50.0,
                          padding: EdgeInsets.all(15.0),
                        ),
                        imageUrl: image,
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        FontAwesomeIcons.user,
                        size: 50.0,
                        color: greyColor,
                      ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.menu),
            ),
            // const SizedBox(width: 5,),
            Text(App.name),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () =>
                Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
              return AddSearchNameChatContainer();
            })),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: BlocConsumer<RoomBloc, RoomState>(
        listener: (context, state) {
          if (state is RoomLoading) {
          } else if (state is RoomLoaded) {
          } else if (state is RoomLoadFailure) {
            print(state.error);
          }
        },
        builder: (context, state) {
          if (state is RoomLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is RoomLoaded) {
            if (state.rooms.length > 0) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return ChatItem(
                          roomID: state.rooms[index].id,
                          lastMessage: state.rooms[index].message.toString(),
                          member: state.rooms[index].member,
                          name: state.rooms[index].name,
                          roomImage: state.rooms[index].photo,
                          type: state.rooms[index].type,
                          createdAt: state.rooms[index].createdAt,
                          roomModel: state.rooms[index],
                        );
                      },
                      itemCount: state.rooms.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                  child: Container(
                child: Text("Hãy nhắn tin đi nào!"),
              ));
            }
          } else {
            return Container(
              child: Center(child: Text("Hãy nhắn tin đi nào!")),
            );
          }
        },
      ),
    );
  }
}
