import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/add_search_name_bloc/add_search_name_bloc.dart';
import 'package:flutter_snap_chat/blocs/add_search_name_bloc/add_search_name_state.dart';
import 'package:flutter_snap_chat/compements/display_user.dart';
import 'package:flutter_snap_chat/screen_display/add_group_display_screen.dart';

class AddSearchNameScreen extends StatefulWidget {
  @override
  _AddSearchNameScreenState createState() => _AddSearchNameScreenState();
}

class _AddSearchNameScreenState extends State<AddSearchNameScreen> {
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Tin nhắn mới"),
        ),
        body: BlocConsumer<AddSearchNameBloc, AddSearchNameState>(
            builder: (context, state) {
              return Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Hãy nhập tên hoặc nhóm",
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Icon(Icons.people),
                          Text("Tạo nhóm mới"),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
                        return AddGroupDisplayScreen(
                          users: (state as AddSearchNameLoaded).users,
                        );
                      }));
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _ListItem(),
                ],
              );
            },
            listener: (context, state) {}));
  }
}

class _ListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddSearchNameBloc, AddSearchNameState>(
        builder: (context, state) {
          if (state is AddSearchNameLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AddSearchNameLoaded) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  return DisplayUser(
                    userModel: state.users[index],
                  );
                });
          }
          return Container();
        },
        listener: (context, state) {});
  }
}
