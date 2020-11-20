import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/widget/bottom_navigate.dart';

class FriendDisplayScreen extends StatefulWidget {
  @override
  _FriendDisplayScreenState createState() => _FriendDisplayScreenState();
}

class _FriendDisplayScreenState extends State<FriendDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("aaaa"),
      ),
      body: Center(
        child: Text("data"),
      ),
      bottomNavigationBar: BottomNavigate(),
    );
  }
}
