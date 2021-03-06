import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/process_contact_bloc/process_contact_bloc.dart';
import 'package:flutter_snap_chat/blocs/process_contact_bloc/process_contact_event.dart';
import 'package:flutter_snap_chat/blocs/process_contact_bloc/process_contact_state.dart';
import 'package:flutter_snap_chat/constant/app_color.dart';
import 'package:flutter_snap_chat/containers/chat_container.dart';
import 'package:flutter_snap_chat/models/contact_model.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

class ProfileTest extends StatefulWidget {
  final String uid;
  final UserModel peerUser;
  final int index;

  const ProfileTest({Key key, @required this.uid, @required this.peerUser, @required this.index}) : super(key: key);

  @override
  _ProfileTestState createState() => _ProfileTestState();
}

class _ProfileTestState extends State<ProfileTest> {
  String roomID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection('rooms').where('member', arrayContainsAny: [widget.uid, widget.peerUser.id]).where('type', isEqualTo: "1").get().then((value) {
          setState(() {
            if (value.docs.length > 0) {
              value.docs.forEach((element) {
                print(element.data()['member']);
                if (element.data()["member"][0] == widget.uid && element["member"][1] == widget.peerUser.id || element["member"][0] == widget.peerUser.id && element["member"][1] == widget.uid) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProcessContactBloc, ProcessContactState>(
          builder: (context, state) {
            if (state is ProcessContactLoading) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is ProcessContactLoaded) {
              return Hero(
                tag: "infoUser ${widget.index}",
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          overflow: Overflow.visible,
                          children: [
                            AspectRatio(
                              aspectRatio: 3 / 2,
                              child: widget.peerUser.background != null
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
                                      imageUrl: widget.peerUser.background,
                                      width: 50.0,
                                      height: 50.0,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: greyColor.withOpacity(0.2),
                                    ),
                            ),
                            Positioned(
                              bottom: -60,
                              child: widget.peerUser.avatar != null
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
                                        imageUrl: widget.peerUser.avatar,
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
                            )
                          ],
                        ),
                        SizedBox(
                          height:60,
                        ),
                        Text(
                          widget.peerUser.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              color: greyColor2,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatContainer(
                                              roomId: roomID,
                                              member: [widget.uid, widget.peerUser.id],
                                              peerAvatar: widget.peerUser.avatar,
                                              peerId: widget.peerUser.id,
                                              peerName: widget.peerUser.name,
                                              perToken: widget.peerUser.fcmToken,
                                            )));
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.chat_outlined),
                                  Text("Nhắn tin"),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            MaterialButton(
                              color: greyColor2,
                              onPressed: () {
                                // FirebaseFirestore.instance.collection("friends").doc(friendId).set({
                                //   '${widget.id}': 'pending_request',
                                //   '${widget.peerId}': 'accept_request',
                                // });
                                // if(documentSnapshot.exists){
                                //   onProcessFriend(snapshot.data['status']);
                                // }else{
                                //   onProcessFriend("-1");
                                // }
                                onProcess(state.contactModel);
                              },
                              child: Row(
                                children: [
                                  state.contactModel.status == '0'
                                      ? Text('Bạn bè')
                                      : state.contactModel.status == '1'
                                          ? state.contactModel.senderId == widget.uid
                                              ? Text("Hủy kết bạn")
                                              : Text('Xac nhan kết bạn')
                                          : Text("Thêm bạn bè"),
                                  state.contactModel.status == '0'
                                      ? Icon(Icons.people_alt)
                                      : state.contactModel.status == '1'
                                          ? state.contactModel.senderId == widget.uid
                                              ? Icon(Icons.person_add_disabled)
                                              : Icon(Icons.check)
                                          : Icon(Icons.person_add_alt_1_sharp),
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
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: _buildAppBar(context),
                      ),
                    )
                  ],
                ),
              );
            }
            return Container();
          },
          listener: (context, state) {}),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Colors.black12.withOpacity(0.1),
      height: 60,
      child: Row(
        children: [
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }

  void onProcess(ContactModel item) {
    if (item == ContactModel.empty) {
      context.read<ProcessContactBloc>().add(ProcessContactAddContact(widget.uid, widget.peerUser.id));
    } else {
      if (item.senderId == widget.uid && item.status == "1") {
        context.read<ProcessContactBloc>().add(ProcessContactDeleteContact(item.contactId));
      } else if (item.senderId != widget.uid && item.status == "1") {
        context.read<ProcessContactBloc>().add(ProcessContactAcpectContact(item.contactId));
      } else if (item.status == "-1") {
        context.read<ProcessContactBloc>().add(ProcessContactAddContactById(item.contactId));
      } else if (item.status == "0") {
        showModal(context.read<ProcessContactBloc>(), item);
      }
    }
  }

  void showModal(ProcessContactBloc processContactBloc, ContactModel item) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  processContactBloc.add(ProcessContactDeleteContact(item.contactId));
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text("Huy ket ban"),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}
