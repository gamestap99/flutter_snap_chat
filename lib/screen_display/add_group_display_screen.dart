import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/constant/app_color.dart';
import 'package:flutter_snap_chat/models/user_model.dart';
import 'package:flutter_snap_chat/screen_display/items/add_name_group.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddGroupDisplayScreen extends StatefulWidget {
  final List<UserModel> users;

  const AddGroupDisplayScreen({Key key, @required this.users}) : super(key: key);

  @override
  _AddGroupDisplayScreenState createState() => _AddGroupDisplayScreenState();
}

class _AddGroupDisplayScreenState extends State<AddGroupDisplayScreen> {
  String id;
  int count;
  List<int> lstIndexAddUsers = [];
  List<bool> lstSelect = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.users.forEach((element) {
      lstSelect.add(false);
    });
  }

  void setCount(int count) {
    setState(() {
      count = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Tạo nhóm chat"),
        actions: [
          lstIndexAddUsers.length > 1
              ? MaterialButton(
                  onPressed: () => Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
                    return AddNameGroup(users: widget.users, lstIndexAddUsers: lstIndexAddUsers);
                  })),
                  child: Text("Tiếp",style: TextStyle(
                    fontSize: 16,
                  ),),
                )
              : Container(),
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
                  fillColor: greyColor2.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40),),
                    borderSide: BorderSide(
                      color: greyColor2,
                    )
                  ),
                  hintText: "Tìm kiếm",
                  prefixIcon: Icon(Icons.search)),
            ),
            lstIndexAddUsers.length > 0
                ? Container(
                    height: 100,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: lstIndexAddUsers.length,
                        itemBuilder: (context, index) {
                          return itemFriendAdd(widget.users[lstIndexAddUsers[index]], lstIndexAddUsers[index]);
                        }),
                  )
                : SizedBox.shrink(),
            lstIndexAddUsers.length > 0 ? Divider(height: 0,) : SizedBox.shrink(),
            const SizedBox(height: 5,),
            Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.users.length,
                  itemBuilder: (context, index) {
                    return itemFriend(widget.users[index], index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemFriend(UserModel userModel, int index) {

    return ListTile(
      leading:  Material(
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
      trailing: !lstSelect[index] ? FaIcon(FontAwesomeIcons.circle) : FaIcon(FontAwesomeIcons.checkCircle),
      onTap: (){
        setState(() {
          lstSelect[index] = !lstSelect[index];
          if (lstSelect[index] == true) {
            lstIndexAddUsers.add(index);
          } else {
            lstIndexAddUsers.remove(index);
          }
        });
      },
    );

  }

  Widget itemFriendAdd(UserModel userModel, int index) {
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
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          '${userModel.name.split(" ").last}',
                          style: TextStyle(color: primaryColor),
                          overflow: TextOverflow.ellipsis,
                        ),
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
                icon: Card(child: Icon(Icons.cancel_rounded)),
                onPressed: () {
                  setState(() {
                    lstIndexAddUsers.remove(index);
                    lstSelect[index] = false;
                  });
                },
              )),
        ],
      ),
    );
  }
}
