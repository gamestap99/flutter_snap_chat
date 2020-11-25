import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/chat.dart';
import 'package:flutter_snap_chat/const.dart';

class ChatItem extends StatefulWidget {
  final String roomID;
  final String lastMessage;
  final List<dynamic> member;
  final String name;
  final String roomImage;
  final int type;
  final String id;
  const ChatItem({
    Key key,
    @required this.roomID,
    this.lastMessage,
    this.member,
    this.name,
    this.roomImage,
    this.type,
    this.id,
  }) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  Map<String, dynamic> room;
  Map<String, dynamic> user;
  String perId;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.type ==1 ){
      print("object");
      print(widget.member);
      widget.member.forEach((element) {
        if(element != widget.id){
          FirebaseFirestore.instance.collection('users').doc(element).get().then((value) {
            if(value.exists){
              setState(() {
                perId=value.id;
                print(value.data());
                user = value.data();
                isLoading=false;
              });
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Container(
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  Material(
                    child: widget.roomImage != null
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
                            imageUrl: widget.roomImage,
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
                          //Task: chua add group name
                          Container(
                            child: Text(
                              user != null ?widget.type == 1 ? user["nickName"].toString(): "":"",
                              style: TextStyle(color: primaryColor),
                            ),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                          ),
                          Container(
                            child: Text(
                              user!= null ? widget.lastMessage : "",
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
                          roomID: widget.roomID,
                              peerId: perId,
                              peerAvatar: user['photoUrl'],
                            )));
              },
              color: greyColor2,
              padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
          )
        : Container();
  }
}
