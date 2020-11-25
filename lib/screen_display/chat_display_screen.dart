import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/chat.dart';
import 'package:flutter_snap_chat/const.dart';
import 'package:flutter_snap_chat/items/chat_item.dart';
import 'package:flutter_snap_chat/widget/bottom_navigate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatDisplayScreen extends StatefulWidget {
  @override
  _ChatDisplayScreenState createState() => _ChatDisplayScreenState();
}

class _ChatDisplayScreenState extends State<ChatDisplayScreen> {
  String id;
  SharedPreferences preferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    print(args["userId"].toString());
    bool isLoading;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rooms').where('member', arrayContainsAny: [args["userId"]]).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return snapshot.hasData
              ? ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return ChatItem(
                      roomID: document.id,
                      lastMessage: document.data()['last_message'],
                      roomImage: document.data()['roomImage'],
                      member: document.data()['member'],
                      type: document.data()['type'],
                      name: document.data()['name'],
                      id: id,
                    );
                  }).toList(),
                )
              : Container(
                  child: Center(
                    child: LinearProgressIndicator(),
                  ),
                );
        },
      ),
      bottomNavigationBar: BottomNavigate(),
    );
  }

  Future<void> getUserID() async {
    preferences = await SharedPreferences.getInstance();
    id = preferences.getString('id') ?? '';
  }

  Widget buildItem(String roomID) {
    FirebaseFirestore.instance.collection('rooms').doc(roomID).get().then((snapshot) {
      if (snapshot.exists) {
        if (snapshot.data()['type'] == true) {
          FirebaseFirestore.instance.collection('users').doc(snapshot.data()['member'][0]).get().then((snapshotUser) {
            if (snapshotUser.exists) {
              print('fsdfsdfsdfsdfsd');
              return Container(
                child: FlatButton(
                  child: Row(
                    children: <Widget>[
                      Material(
                        child: snapshotUser.data()['photoUrl'] != null
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
                                imageUrl: snapshotUser.data()['photoUrl'],
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
                      Flexible(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'Tên: ${snapshotUser.data()['nickname']}',
                                  style: TextStyle(color: primaryColor),
                                ),
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                              ),
                              Container(
                                child: Text(
                                  snapshot.data()['last_message'],
                                  style: TextStyle(color: primaryColor),
                                ),
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              )
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
                            builder: (context) => Chat(
                                  peerId: snapshot.data()['member'][0],
                                  peerAvatar: snapshotUser.data()['photoUrl'],
                              roomID: roomID,
                                )));
                  },
                  color: greyColor2,
                  padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
              );
            } else {
              print('loi');
            }
          });
        }
      } else {
        print("looix");
      }
    });
    return Container();
  }
}
