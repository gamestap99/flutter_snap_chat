
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/const.dart';

class ProfileScreen extends StatefulWidget {
  final String id;
  final String peerId;
  final String peerAvatar;
  final String peerName;

  const ProfileScreen({
    Key key,
    @required this.id,
    @required this.peerId,
    @required this.peerAvatar,
    @required this.peerName,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String friendId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createFriendId();
  }
  void createFriendId(){
    if (widget.id.hashCode <= widget.peerId.hashCode) {
      friendId = '${widget.id}-${widget.peerId}';
    } else {
      friendId = '${widget.peerId}-${widget.id}';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("friends").doc(friendId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            DocumentSnapshot documentSnapshot = snapshot.data;
            return Padding(
              padding: const EdgeInsets.fromLTRB(10,20,10,30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.peerAvatar != null ? Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(
                              themeColor),
                        ),
                        width: 150.0,
                        height: 150.0,
                        padding: EdgeInsets.all(20.0),
                      ),
                      imageUrl: widget.peerAvatar,
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius:
                    BorderRadius.all(Radius.circular(75.0)),
                    clipBehavior: Clip.hardEdge,
                  ) : Icon(
                    Icons.account_circle,
                    size: 150.0,
                    color: greyColor,
                  ),
                  Text(widget.peerName,style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection("friends").doc(friendId).set({
                            '${widget.id}': 'pending_request',
                            '${widget.peerId}': 'accept_request',
                          });
                        },
                        child: Row(
                          children: [
                            documentSnapshot.exists ? snapshot.data[widget.id] !=  'pending_request' ? snapshot.data[widget.id] == 'success' ? Text('Bạn bè')  : Text("Thêm bạn bè"): Text('Hủy kết bạn'):Text("Thêm bạn bè"),
                            documentSnapshot.exists ? snapshot.data[widget.id] !=  'pending_request'  ? snapshot.data[widget.id] == 'success' ? Icon(Icons.people_alt):Icon(Icons.person_add_alt_1_sharp):Icon(Icons.person_add_alt_1_sharp):Icon(Icons.person_add_alt_1_sharp),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Text("Chat"),
                            Icon(Icons.chat_outlined),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
