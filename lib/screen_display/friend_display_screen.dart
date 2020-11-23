import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/items/friend_item.dart';
import 'package:flutter_snap_chat/widget/bottom_navigate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendDisplayScreen extends StatefulWidget {
  @override
  _FriendDisplayScreenState createState() => _FriendDisplayScreenState();
}

class _FriendDisplayScreenState extends State<FriendDisplayScreen> {
  String id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readIdLocal();
  }

  Future<void> readIdLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("aaaa"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("friends").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return FriendItem(lstDocuments: snapshot.data.documents,id: id,);

          }),
      bottomNavigationBar: BottomNavigate(),
    );
  }
}
