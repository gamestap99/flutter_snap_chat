import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/add_search_name_bloc/add_search_name_bloc.dart';
import 'package:flutter_snap_chat/blocs/add_search_name_bloc/add_search_name_state.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/models/room_model.dart';
import 'package:flutter_snap_chat/screen_display/add_group_display_screen.dart';
import 'package:flutter_snap_chat/screen_display/items/chat_item.dart';

class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    String uid = context.select((FriendProviderCubit bloc) => bloc.state.userModel.id.toString());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Nhóm chat"),
      ),
      body: BlocConsumer<AddSearchNameBloc, AddSearchNameState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(Icons.group_add),
                  title: Text("Tạo nhóm mới"),
                  onTap: (){
                    if (state is AddSearchNameLoaded) {
                      Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
                        return AddGroupDisplayScreen(
                          users: state.users,
                        );
                      }));
                    }
                  },
                ),
                Divider(height: 0,),

                Padding(
                  padding: const EdgeInsets.fromLTRB(15,10,10,10),
                  child: Text("Nhóm của bạn",style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),),
                ),
                Flexible(
                  child: _ListItem(
                    uid: uid,
                  ),
                ),
              ],
            );
          },
          listener: (context, state) {}),
    );
  }
}

class _ListItem extends StatelessWidget {
  final String uid;

  const _ListItem({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('rooms').where('member', arrayContainsAny: [uid]).where('type', isEqualTo: "0").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return snapshot.data.docs.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatItem(
                    roomID: snapshot.data.docs[index].id,
                    lastMessage: snapshot.data.docs[index]['last_message'],
                    member: List<String>.from(snapshot.data.docs[index]['member']),
                    name: snapshot.data.docs[index]['name'],
                    roomImage: snapshot.data.docs[index]['roomImage'],
                    type: snapshot.data.docs[index]['type'],
                    id: uid,
                    roomModel: RoomModel(
                      id: snapshot.data.docs[index].id,
                      name: snapshot.data.docs[index]['name'],
                      message: snapshot.data.docs[index]['last_message'],
                      photo: snapshot.data.docs[index]['roomImage'],
                      type: snapshot.data.docs[index]['type'],
                      member: List<String>.from(snapshot.data.docs[index]['member']),
                      createdAt: snapshot.data.docs[index]['created_at'],
                    ),
                    createdAt: snapshot.data.docs[index]['created_at'],
                  );
                })
            : Container(
                child: Center(
                  child: Text('No data'),
                ),
              );
      },
    );
  }
}
