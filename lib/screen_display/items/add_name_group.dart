import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/constant/app_color.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

class AddNameGroup extends StatefulWidget {
  final List<UserModel> users;

  final List<int> lstIndexAddUsers;

  const AddNameGroup({Key key, @required this.users, @required this.lstIndexAddUsers}) : super(key: key);

  @override
  _AddNameGroupState createState() => _AddNameGroupState();
}

class _AddNameGroupState extends State<AddNameGroup> {
  TextEditingController txtName;
  final _key = GlobalKey<FormState>();
  List<String> users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtName = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String _uid = context.select((AuthenticationBloc bloc) => bloc.state.user.id.toString());
    users.add(_uid);
    return Scaffold(
      appBar: AppBar(
        title: Text("Nhóm mới"),
        actions: [
          MaterialButton(
            onPressed: () {
              addGroup();
            },
            child: Text(
              "Tạo",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              Text(
                "Đặt tên đoạn chat mới",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextFormField(
                controller: txtName,
                decoration: InputDecoration(
                  hintText: "Tên nhóm (Bắt buộc)",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Tên không được để trôngs";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.lstIndexAddUsers.length,
                  itemBuilder: (context, index) {
                    users.add(widget.users[widget.lstIndexAddUsers[index]].id);
                    return itemFriend(widget.users[widget.lstIndexAddUsers[index]], index);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemFriend(UserModel userModel, int index) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Material(
        child: userModel.avatar != null
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
                imageUrl: userModel.avatar,
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
      title: Text(
        '${userModel.name}',
        style: TextStyle(color: primaryColor),
      ),
    );
  }

  void addGroup() {
    if (_key.currentState.validate()) {
      // context.read<AddSearchNameBloc>().add(AddGroup(users, txtName.text));
      FirebaseFirestore.instance.collection("rooms").add({
        "last_message": "",
        "member": users,
        "name": txtName.text,
        "roomImage": null,
        "type": "0",
        "created_at":DateTime.now().microsecondsSinceEpoch.toString(),
      }).then((value) => Navigator.of(context).pushNamedAndRemoveUntil("/chat_display", (route) => false));
    }
  }
}
