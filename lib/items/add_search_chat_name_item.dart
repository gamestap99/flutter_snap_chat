
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/compements/display_user.dart';
import 'package:flutter_snap_chat/screen_display/add_group_display_screen.dart';

class AddSearchChatNameItem extends StatefulWidget {
  final   List<String> idFriend;

  const AddSearchChatNameItem({Key key, this.idFriend}) : super(key: key);
  @override
  _AddSearchChatNameItemState createState() => _AddSearchChatNameItemState();
}

class _AddSearchChatNameItemState extends State<AddSearchChatNameItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: "Hãy nhập tên hoặc nhóm",
          ),
        ),
        InkWell(
          child: Row(
            children: [
              Icon(Icons.people),
              Text("Tạo nhóm mới"),
            ],
          ),
          onTap: (){
            Navigator.of(context).push(CupertinoPageRoute(builder: (_){
              return AddGroupDisplayScreen();
            }));
          },
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.idFriend.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                  future: FirebaseFirestore.instance.collection("users").doc(widget.idFriend[index]).get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      print("kakakakaka");
                      return DisplayUser(document:snapshot.data);
                    }
                    return Text("loading");
                  });
            }),
      ],
    );
  }
}
