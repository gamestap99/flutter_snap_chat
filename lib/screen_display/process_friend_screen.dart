

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/process_contact_bloc/process_contact_bloc.dart';
import 'package:flutter_snap_chat/blocs/process_contact_bloc/process_contact_event.dart';
import 'package:flutter_snap_chat/blocs/process_friend_bloc/process_friend_bloc.dart';
import 'package:flutter_snap_chat/blocs/process_friend_bloc/process_friend_state.dart';
import 'package:flutter_snap_chat/const.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

class ProcessFriendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lời mời kết bạn"),
      ),
      body: BlocConsumer<ProcessFriendBloc,ProcessFriendState>(
          builder: (context, state) {
            if (state is ProcessFriendLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProcessFriendLoaded) {
              return state.contacts.length > 0 ? ListView.builder(
                shrinkWrap: true,
              itemCount: state.users.length,
              itemBuilder: (context,index){
                return buidItem(state.users[index],context,state.contacts[index].contactId);
              }) : Container(child: Center(child: Text("Không có lời mời nào"),),);
            }
            return Container();
          },
          listener: (context, state) {}),
    );
  }
  Widget buidItem(UserModel userModel,BuildContext context,String contactId){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Material(
               child: userModel.photo != null
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
                imageUrl: userModel.photo,
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
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            userModel.name,
                            style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 17),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                      ],
                    ),

                  ),
                ),
                Padding(
                  padding:  EdgeInsets.fromLTRB(10,0,0,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton(
                        key: const Key('process_acpect'),
                        child: const Text('Chấp nhận'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: const Color(0xFFFFD600),
                        onPressed: (){
                          context.read<ProcessContactBloc>().add(ProcessContactAcpectContact(contactId));
                        },
                      ),
                      SizedBox(width: 20,),
                      RaisedButton(
                        key: const Key('process_delete'),
                        child: const Text('Xóa'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: const Color(0xFFFFD600),
                        onPressed: (){
                          context.read<ProcessContactBloc>().add(ProcessContactDeleteContact(contactId));
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
