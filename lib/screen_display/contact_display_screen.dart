import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/contact_bloc/bloc.dart';
import 'package:flutter_snap_chat/models/user_model.dart';
import 'package:flutter_snap_chat/screen_display/items/contact_item.dart';
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
          onTap: () {
            focusNode.requestFocus();
          },
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
                  return buildItem(context, state.users[index], _uid, index);
                });
          }
          return Container();
        },
        listener: (context, state) {},
      ),
    );
  }

  Widget buildItem(BuildContext context, UserModel userModel, String uid, int index) {
    if (userModel.id == uid) {
      return SizedBox.shrink();
    } else {
      return ContactItem(
        userModel: userModel,
        uid: uid,
        index: index,
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
