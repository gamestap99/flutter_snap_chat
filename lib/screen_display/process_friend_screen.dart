import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/process_contact_bloc/process_contact_bloc.dart';
import 'package:flutter_snap_chat/blocs/process_contact_bloc/process_contact_event.dart';
import 'package:flutter_snap_chat/blocs/process_friend_bloc/process_friend_bloc.dart';
import 'package:flutter_snap_chat/blocs/process_friend_bloc/process_friend_state.dart';
import 'package:flutter_snap_chat/constant/app_color.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

class ProcessFriendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Lời mời kết bạn",
          style: TextStyle(
            color: primaryColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: primaryColor,
        ),
      ),
      body: BlocConsumer<ProcessFriendBloc, ProcessFriendState>(
          builder: (context, state) {
            if (state is ProcessFriendLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProcessFriendLoaded) {
              return state.contacts.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        return buidItem(state.users[index], context, state.contacts[index].contactId);
                      })
                  : Container(
                      child: Center(
                        child: Text("Không có lời mời nào"),
                      ),
                    );
            }
            return Container();
          },
          listener: (context, state) {}),
    );
  }

  Widget buidItem(UserModel userModel, BuildContext context, String contactId) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          userModel.avatar != null
              ? CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    userModel.avatar,
                  ),
                )
              : Icon(
                  Icons.account_circle,
                  size: 100.0,
                  color: greyColor,
                ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                          style: TextStyle(
                            // color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      key: const Key('process_acpect'),
                      child: const Text(
                        'Chấp nhận',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: primaryColor,
                      onPressed: () {
                        context.read<ProcessContactBloc>().add(ProcessContactAcpectContact(contactId));
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    RaisedButton(
                      key: const Key('process_delete'),
                      child: const Text(
                        'Xóa',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: greyColor2,
                      onPressed: () {
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
    );
  }
}
