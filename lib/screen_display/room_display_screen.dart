import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/room_bloc/room_bloc.dart';
import 'package:flutter_snap_chat/blocs/room_bloc/room_state.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';

import 'package:flutter_snap_chat/const.dart';
import 'package:flutter_snap_chat/containers/add_search_name_chat_container.dart';
import 'package:flutter_snap_chat/router.dart';
import 'package:flutter_snap_chat/screen_display/items/chat_item.dart';
import 'package:flutter_snap_chat/widget/bottom_navigate.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RoomDisplayScreen extends StatefulWidget {
  final String uid;

  const RoomDisplayScreen({Key key,@required this.uid}) : super(key: key);
  @override
  _RoomDisplayScreenState createState() => _RoomDisplayScreenState();
}

class _RoomDisplayScreenState extends State<RoomDisplayScreen> {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registerNotification();
    configLocalNotification();
  }
  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid ? showNotification(message['notification']) : showNotification(message['aps']['alert']);
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
      FirebaseFirestore.instance.collection('users').doc(widget.uid).update({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }


  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.dfa.flutterchatdemo' : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
    print(message['body'].toString());
    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(), message['body'].toString(), platformChannelSpecifics, payload: json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, 'plain title', 'plain body', platformChannelSpecifics, payload: 'item x');
  }
  @override
  Widget build(BuildContext context) {
    String uid = context.select((AuthenticationBloc bloc) => bloc.state.user.id.toString());
    String image = context.select((UserProviderCubit bloc) => bloc.state.userModel.photo);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            MaterialButton(
              child: Material(
                child: image != null
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
                  imageUrl: image,
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
              onPressed: ()=>Navigator.of(context).pushNamed(AppRoutes.menu),
            ),
            Text("Chat"),
          ],
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () =>Navigator.of(context).push(CupertinoPageRoute(builder: (_){
              return AddSearchNameChatContainer();
            })),
          ),
        ],
      ),
      body: BlocConsumer<RoomBloc, RoomState>(
        listener: (context, state) {
          if(state is RoomLoading){

          }else if(state is RoomLoaded){

          }
          else if(state is RoomLoadFailure){
            print(state.error);
          }
        },
        builder: (context, state) {
          if (state is RoomLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is RoomLoaded) {
            if(state.rooms.length > 0){
              return ListView(
                children: state.rooms.map((e) {
                  print("-----------------"+ e.name);
                  return ChatItem(
                    roomID: e.id,
                    lastMessage: e.message.toString(),
                    member: e.member,
                    name: e.name,
                    roomImage: e.photo,
                    type: e.type,
                    id: uid,
                  );
                }).toList(),
              );
            }else{
              return Container(child: Text("Chưa có đoan chat nào"),);
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
