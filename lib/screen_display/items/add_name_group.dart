import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/blocs/add_search_name_bloc/add_search_name_bloc.dart';
import 'package:flutter_snap_chat/blocs/add_search_name_bloc/add_search_name_event.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/const.dart';
import 'package:flutter_snap_chat/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  List<String> users=[];
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
            onPressed: () {addGroup();},
            child: Text("Tạo"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              Text("Đặt tên đoạn chat mới"),
              TextFormField(
                controller: txtName,
                decoration: InputDecoration(
                  hintText: "Tên nhóm (Bắt buộc)",
                ),
                validator: (value){
                  if(value.isEmpty){
                    return "Tên không được để trôngs";
                  }
                  return null;
                },
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
    return Container(
      child: Row(
        children: <Widget>[
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
          Container(
            child: Container(
              child: Text(
                '${userModel.name}',
                style: TextStyle(color: primaryColor),
              ),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
            ),
            margin: EdgeInsets.only(left: 20.0),
          ),
        ],
      ),
    );
  }
  void addGroup(){
    if(_key.currentState.validate()){
      // context.read<AddSearchNameBloc>().add(AddGroup(users, txtName.text));
      FirebaseFirestore.instance.collection("rooms").add({
        "last_message":"",
        "member": users,
        "name": txtName.text,
        "roomImage":null,
        "type":"0",
      }).then((value) => Navigator.of(context).pushNamedAndRemoveUntil("/chat_display", (route) => false));
    }
  }
}
