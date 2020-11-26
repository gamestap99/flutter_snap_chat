
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/compements/display_user.dart';
import 'package:flutter_snap_chat/items/add_search_chat_name_item.dart';

class AddSearchNameChat extends StatefulWidget {

  final String id;

  const AddSearchNameChat({Key key,@required this.id}) : super(key: key);
  @override
  _AddSearchNameChatState createState() => _AddSearchNameChatState();
}

class _AddSearchNameChatState extends State<AddSearchNameChat> {
  List<String> idRequest = [];
  List<String> idFriend = [];
  List<DocumentSnapshot> lstDocuments;
  bool isLoading= false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading=true;
    });
    FirebaseFirestore.instance.collection("friends").get().then((value) {
      // setState(() {
      //   lstDocuments =value.docs;
      // });
      value.docs.forEach((element) {
        List<String> strings = element.id.split("-");
        if (strings[0] == widget.id || strings[1] == widget.id) {
          print(element.data()[widget.id]);
          print(element.data()[widget.id]);
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
      setState(() {
        isLoading =false;
      });
    });
    // getData();
  }

  void getData() {
    lstDocuments.forEach((element) {
      List<String> strings = element.id.split("-");
      if (strings[0] == widget.id || strings[1] == widget.id) {
        print(element.data()[widget.id]);
        print(element.data()[widget.id]);
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Tin nhắn mới"),
      ),
      body: AddSearchChatNameItem(idFriend: idFriend,),
    );
  }
}
