import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/items/add_group_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddGroupDisplayScreen extends StatefulWidget {
  @override
  _AddGroupDisplayScreenState createState() => _AddGroupDisplayScreenState();
}

class _AddGroupDisplayScreenState extends State<AddGroupDisplayScreen> {
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
        title: Text("Thêm thành viên"),
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
            return AddGroupItem(
              lstDocuments: snapshot.data.documents,
              id: id,
            );
          }),
    );
  }
}
