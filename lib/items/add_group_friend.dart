import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/const.dart';
import 'package:flutter_snap_chat/items/add_name_group.dart';

class AddGroupFriend extends StatefulWidget {
  final List<String> idFriend;
  final List<bool> lstSelect;


  const AddGroupFriend({Key key, @required this.idFriend, @required this.lstSelect}) : super(key: key);

  @override
  _AddGroupFriendState createState() => _AddGroupFriendState();
}

class _AddGroupFriendState extends State<AddGroupFriend> {
  List<DocumentSnapshot> users = [];
  List<int> lstIndexAddUsers = [];

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    getUser();
  }

  void getUser() {
    widget.idFriend.forEach((element) {
      FirebaseFirestore.instance.collection("users").doc(element).get().then((value) {
        users.add(value);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tạo nhóm chat"),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
              return AddNameGroup(users: users, lstIndexAddUsers: lstIndexAddUsers);
            })),
            child: Text("Tiếp"),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  hintText: "Tìm kiếm",
                  prefixIcon: Icon(Icons.search)),
            ),
            lstIndexAddUsers.length > 0
                ? Container(
                    color: Colors.red,
                    height: 100,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: lstIndexAddUsers.length,
                        itemBuilder: (context, index) {
                          return itemFriendAdd(users[index], index);
                        }),
                  )
                : Text(""),
            Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return itemFriend(users[index], index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemFriend(DocumentSnapshot document, int index) {
    return InkWell(
      child: Container(
        child: Row(
          children: <Widget>[
            Material(
              child: document.data()['photoUrl'] != null
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
                      imageUrl: document.data()['photoUrl'],
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
                  '${document.data()['nickname']}',
                  style: TextStyle(color: primaryColor),
                ),
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
              ),
              margin: EdgeInsets.only(left: 20.0),
            ),
            !widget.lstSelect[index] ? Icon(Icons.add_circle_outline) : Icon(Icons.add_circle),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          lstIndexAddUsers.add(index);
          print(lstIndexAddUsers.length);
          widget.lstSelect[index] = !widget.lstSelect[index];
        });
      },
    );
  }

  Widget itemFriendAdd(DocumentSnapshot document, int index) {
    return Container(
      width: 80,
      child: Stack(
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 5,
                ),
                Material(
                  child: document.data()['photoUrl'] != null
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
                          imageUrl: document.data()['photoUrl'],
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${document.data()['nickname']}' + 'llllllllllllllllllll',
                        style: TextStyle(color: primaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: IconButton(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                icon: Icon(Icons.clear_sharp),
                onPressed: () {
                  setState(() {
                    lstIndexAddUsers.removeAt(index);
                  });
                },
              )),
        ],
      ),
    );
  }
}
