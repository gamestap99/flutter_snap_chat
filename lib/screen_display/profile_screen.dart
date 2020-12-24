import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/blocs/contact_bloc/bloc.dart';
import 'package:flutter_snap_chat/const.dart';
import 'package:flutter_snap_chat/containers/chat_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ProfileScreen extends StatefulWidget {
  final String id;
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final ContactCubit contactCubit;
  const ProfileScreen({
    Key key,
    @required this.id,
    @required this.peerId,
    @required this.peerAvatar,
    @required this.peerName,
    @required this.contactCubit,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String friendId;
  String roomID;
  String contactId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection('rooms').where('member', arrayContainsAny: [widget.id, widget.peerId]).get().then((value) {
          setState(() {
            if (value.docs.length > 0) {
              value.docs.forEach((element) {
                print(element.data()['member']);
                if (element.data()["member"][0] == widget.id && element["member"][1] == widget.peerId || element["member"][0] == widget.peerId && element["member"][1] == widget.id) {
                  setState(() {
                    roomID = element.id;
                  });
                }
              });

              print(roomID);
            } else {
              print("--------------------------------------");
              print("object");
            }

            // roomID = value.docs[0].data().toString();
          });
        });
    FirebaseFirestore.instance.collection('contacts').where('senderId',whereIn:[widget.id,widget.peerId]).get().then((value){
      if(value.docs.length >0 ){
        value.docs.forEach((element) {
          if(element['senderId'] == widget.id && element['receiveId'] ==widget.peerId ||element['senderId'] == widget.peerId && element['receiveId'] ==widget.id ){
            setState(() {
              contactId = element.id;
              print("contactId: " +contactId.toString());
            });
          }
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("contacts")
              .doc(contactId.toString()).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            DocumentSnapshot documentSnapshot = snapshot.data;
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.peerAvatar != null
                      ? Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
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
                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                          clipBehavior: Clip.hardEdge,
                        )
                      : Icon(
                          Icons.account_circle,
                          size: 150.0,
                          color: greyColor,
                        ),
                  Text(
                    widget.peerName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          // FirebaseFirestore.instance.collection("friends").doc(friendId).set({
                          //   '${widget.id}': 'pending_request',
                          //   '${widget.peerId}': 'accept_request',
                          // });
                          if(documentSnapshot.exists){
                            onProcessFriend(snapshot.data['status']);
                          }else{
                            onProcessFriend("-1");
                          }
                        },
                        child: Row(
                          children: [
                            documentSnapshot.exists
                                ? snapshot.data['status'] == '0'
                                        ? Text('Bạn bè')
                                        :snapshot.data['status'] == '1' ?
                                           snapshot.data['senderId'] == widget.id ? Text("Hủy kết bạn")
                                    : Text('Xac nhan kết bạn')
                                : Text("Thêm bạn bè") :Text("Thêm bạn bè"),
                            // documentSnapshot.exists
                            //     ? snapshot.data[widget.id] != 'pending_request'
                            //         ? snapshot.data[widget.id] == 'success'
                            //             ? Icon(Icons.people_alt)
                            //             : Icon(Icons.person_add_alt_1_sharp)
                            //         : Icon(Icons.person_add_alt_1_sharp)
                            //     : Icon(Icons.person_add_alt_1_sharp),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatContainer(
                                        roomId: roomID,
                                        member: [widget.id, widget.peerId],
                                        peerAvatar: widget.peerAvatar,
                                        peerId: widget.peerId,
                                      )));
                        },
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
  void onProcessFriend(String type,{String contactId}){
    if(type == "0"){

    }else if(type == "1"){

    }else{
      widget.contactCubit.addContact(widget.id, widget.peerId, "1");
    }
  }
}
