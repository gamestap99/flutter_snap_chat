import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/chat_bloc/chat_cubit.dart';
import 'package:flutter_snap_chat/blocs/chat_bloc/chat_state.dart';
import 'package:flutter_snap_chat/items/chat_item.dart';
import 'package:flutter_snap_chat/widget/bottom_navigate.dart';

class ChatDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uid = context.select((AuthenticationBloc bloc) => bloc.state.user.id.toString());
    return Scaffold(

      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if(state is ChatLoading){

          }else if(state is ChatLoaded){

          }
          else if(state is ChatLoadFailure){
            print(state.error);
          }
        },
        builder: (context, state) {
          if (state is ChatLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ChatLoaded) {
            return ListView(
              children: state.rooms.map((e) {
                return ChatItem(
                  roomID: e.id,
                  lastMessage: e.message.toString(),
                  member: e.member,
                  name: e.name,
                  roomImage: e.photo,
                  type: e.type,
                  id: uid,
                );
              }).toList(),
            );
          } else {
            return Container(
              child: Text("kkkk"),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigate(),
    );
  }
}
