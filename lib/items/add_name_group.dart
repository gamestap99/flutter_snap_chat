import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/const.dart';

class AddNameGroup extends StatefulWidget {
  final List<DocumentSnapshot> users;

  final List<int> lstIndexAddUsers;

  const AddNameGroup({Key key, @required this.users, @required this.lstIndexAddUsers}) : super(key: key);

  @override
  _AddNameGroupState createState() => _AddNameGroupState();
}

class _AddNameGroupState extends State<AddNameGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nhóm mới"),
        actions: [
          MaterialButton(
            onPressed: () {},
            child: Text("Tạo"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Đặt tên đoạn chat mới"),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Tên nhóm (Bắt buộc)",
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.lstIndexAddUsers.length,
                itemBuilder: (context, index) {
                  return itemFriend(widget.users[index], index);
                }),
          ],
        ),
      ),
    );
  }

  Widget itemFriend(DocumentSnapshot document, int index) {
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
          Container(
            child: Container(
              child: Text(
                '${document.data()['nickname']}',
                style: TextStyle(color: primaryColor),
              ),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
            ),
            margin: EdgeInsets.only(left: 20.0),
          ),
        ],
      ),
    );
  }
}
