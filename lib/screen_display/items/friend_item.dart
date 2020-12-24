import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/const.dart';

class FriendItem extends StatefulWidget {
  final List<DocumentSnapshot> lstDocuments;
  final String id;

  const FriendItem({Key key, @required this.lstDocuments, @required this.id}) : super(key: key);

  @override
  _FriendItemState createState() => _FriendItemState();
}

class _FriendItemState extends State<FriendItem> {
  List<String> idRequest = [];
  List<String> idFriend = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() {
    widget.lstDocuments.forEach((element) {
      List<String> strings = element.id.split("-");
      if (strings[0] == widget.id || strings[1] == widget.id) {
        if (element.data()[widget.id] == 'accept_request') {
          if (strings[0] == widget.id) {
            idRequest.add(strings[1]);
          } else {
            idRequest.add(strings[0]);
          }
        } else if(element.data()[widget.id] == 'success'){
          if (strings[0] == widget.id) {
            idFriend.add(strings[1]);
          } else {
            idFriend.add(strings[0]);
          }
          print(idFriend.length);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              Text("Lời mời kết bạn"),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: idRequest.length < 10 ? idRequest.length : 10,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: FirebaseFirestore.instance.collection("users").doc(idRequest[index]).get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.connectionState == ConnectionState.done) {
                            return itemRequest(snapshot.data);
                          }
                          return Text("loading");
                        });
                  }),
            ],
          ),
        ),
        Container(
          child: Column(
          children: [
            Text("Bạn bè"),
            ListView.builder(
                shrinkWrap: true,
                itemCount: idFriend.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                      future: FirebaseFirestore.instance.collection("users").doc(idFriend[index]).get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          return itemFriend(snapshot.data);
                        }
                        return Text("loading");
                      });
                }),
          ],
        ),),
      ],
    );
  }
  void acceptRequest(String peerId){
    String friendId;
    if (widget.id.hashCode <= peerId.hashCode) {
      friendId = '${widget.id}-$peerId';
    } else {
      friendId = '$peerId-${widget.id}';
    }
    FirebaseFirestore.instance.collection("friends").doc(friendId).update({
      '${widget.id}' : 'success',
      '$peerId': 'success',
    });
  }
  Widget itemRequest(DocumentSnapshot document) {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: document.data()['photoUrl'] != null
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
              imageUrl: document.data()['photoUrl'],
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
                      'Tên: ${document.data()['nickname']}',
                      style: TextStyle(color: primaryColor),
                    ),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                  ),
                  Container(
                    child: Row(
                      children: [
                        MaterialButton(
                          onPressed: () {
                            acceptRequest(document.id);
                          },
                          child: Text("Xác nhận"),
                          color: Colors.orange,
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: Text("Hủy bỏ"),
                          color: Colors.white38,
                        ),
                      ],
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
    );
  }
  Widget itemFriend(DocumentSnapshot document) {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: document.data()['photoUrl'] != null
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
              imageUrl: document.data()['photoUrl'],
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
                      '${document.data()['nickname']}',
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
    );
  }
}


