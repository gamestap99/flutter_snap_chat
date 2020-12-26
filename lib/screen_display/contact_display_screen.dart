import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/contact_bloc/bloc.dart';
import 'package:flutter_snap_chat/const.dart';
import 'package:flutter_snap_chat/containers/profile_container.dart';
import 'package:flutter_snap_chat/models/user_model.dart';
import 'package:flutter_snap_chat/widget/bottom_navigate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactDisplayScreen extends StatefulWidget {
  @override
  _ContactDisplayScreenState createState() => _ContactDisplayScreenState();
}

class _ContactDisplayScreenState extends State<ContactDisplayScreen> {
  bool isLoading = false;
  SharedPreferences prefs;
  ContactCubit _contactCubit;
  FocusNode focusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _contactCubit = BlocProvider.of<ContactCubit>(context);
    focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    String _uid = context.select((AuthenticationBloc bloc) => bloc.state.user.id.toString());
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            focusNode.requestFocus();},
          child: Icon(Icons.search),
        ),
        title: _InputSearchName(
          focusNode: focusNode,
        ),
      ),
      body: BlocConsumer<ContactCubit, ContactState>(
        builder: (context, state) {
          if (state is ContactLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ContactLoaded) {
            return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (_, index) {
                  return buildItem(context, state.users[index], _uid);
                });
          }
          return Container();
        },
        listener: (context, state) {},
      ),
    );
  }

  Widget buildItem(BuildContext context, UserModel userModel, String uid) {
    if (userModel.id == uid) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
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
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          userModel.name,
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileContainer(
                          uid: uid,
                          peerUser: userModel,
                        )));
          },
          color: greyColor2,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }
}

class _InputSearchName extends StatelessWidget {
  final FocusNode focusNode;

  const _InputSearchName({Key key, this.focusNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactCubit, ContactState>(
        builder: (context, state) {
          return TextField(
            focusNode: focusNode,
            keyboardType: TextInputType.text,
            autofocus: false,
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
            ),
            onChanged: (value) {
              BlocProvider.of<ContactCubit>(context).searchName(value);
            },
            decoration: InputDecoration(
              hintText: "Nhập tên bạn bè của bạn",
              hintStyle: TextStyle(color: Colors.white, fontSize: 13),
              isDense: true,
              enabledBorder: InputBorder.none,
              focusedBorder: UnderlineInputBorder(),
              // border: OutlineInputBorder(
              //   borderRadius:
              //   BorderRadius.circular(50.0),
              //   borderSide: BorderSide.none,
              // )
            ),
          );
        },
        listener: (context, state) {});
  }

}
