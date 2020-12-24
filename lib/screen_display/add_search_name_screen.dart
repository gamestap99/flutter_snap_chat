import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/friend_bloc/bloc.dart';
import 'package:flutter_snap_chat/screen_display/items/add_search_chat_name_item.dart';

class AddSearchNameChat extends StatefulWidget {
  @override
  _AddSearchNameChatState createState() => _AddSearchNameChatState();
}

class _AddSearchNameChatState extends State<AddSearchNameChat> {
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> _friend = context.select((FriendBloc bloc) => (bloc.state as FriendLoaed).friends);
    return Scaffold(
      appBar: AppBar(
        title: Text("Tin nhắn mới"),
      ),
      body: AddSearchChatNameItem(
        idFriend: _friend,
      ),
    );
  }
}
