import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/const.dart';
import 'package:flutter_snap_chat/containers/chat_container.dart';
import 'package:flutter_snap_chat/containers/chat_group_container.dart';
import 'package:flutter_snap_chat/models/room_model.dart';
import 'package:flutter_snap_chat/models/user_model.dart';
import 'package:intl/intl.dart';

class ChatItem extends StatefulWidget {
  final String roomID;
  final String lastMessage;
  final List<String> member;
  final String name;
  final String roomImage;
  final String type;
  final String id;
  final RoomModel roomModel;
  final String createdAt;

  const ChatItem({
    Key key,
    @required this.roomID,
    @required this.lastMessage,
    @required this.member,
    @required this.name,
    @required this.roomImage,
    @required this.type,
    @required this.id,
    @required this.roomModel,
    @required this.createdAt,
  }) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  Map<String, dynamic> room;
  Map<String, dynamic> user;
  String perId;
  String peerAvatar;
  bool isLoading = false;
  UserModel _receiver;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.type == "1") {
      widget.member.forEach((element) {
        if (element != widget.id) {
          setState(() {
            isLoading = true;
          });
          FirebaseFirestore.instance
              .collection('users')
              .doc(element)
              .get()
              .then((value) {
            if (value.exists) {
              setState(() {
                perId = value.id;
                peerAvatar = value["photoUrl"];
                print(value.data());
                user = value.data();
                _receiver = UserModel.fromSnapShot(value);
                isLoading = false;
              });
            }
          });
        }
      });
    }
    print("----------------?????????-" + widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Container(
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  Material(
                    child: widget.roomImage != null || widget.type == "1"
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
                            imageUrl: widget.type == "0"
                                ? widget.roomImage
                                : peerAvatar,
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
                              widget.type == "0"
                                  ? widget.name
                                  : user["nickname"],
                              style: TextStyle(
                                // color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                  child: Text(
                                    widget.lastMessage,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  margin:
                                      EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                ),
                              ),
                              Text("-"),
                              Container(
                                child: Text(
                                  DateTime.fromMicrosecondsSinceEpoch(
                                          int.parse(widget.createdAt))
                                      .toString(),
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                ),
                                alignment: Alignment.centerLeft,
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 5.0),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                if (widget.type == "1") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatContainer(
                                roomId: widget.roomID,
                                member: widget.member,
                                peerAvatar: peerAvatar,
                                peerId: perId,
                                perToken: user["pushToken"],
                                peerName: user['nickname'], receiver: _receiver,
                              )));
                } else {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (_) => ChatGroupContainer(
                            roomModel: widget.roomModel,
                          )));
                }
              },
              // color: greyColor2,
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
          )
        : Container();
  }
}
