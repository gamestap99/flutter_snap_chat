import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/compements/message_input.dart';
import 'package:flutter_snap_chat/compements/message_item.dart';
import 'package:flutter_snap_chat/constant/app_color.dart';

class ContactChat extends StatefulWidget {
  final String peerID;
  final String perAvatar;
  final String name;
  final String id;

  const ContactChat({Key key, @required this.peerID, @required this.perAvatar, @required this.name, @required this.id}) : super(key: key);

  @override
  _ContactChatState createState() => _ContactChatState();
}

class _ContactChatState extends State<ContactChat> {
  bool isLoading = false;
  String roomId;
  final ScrollController listScrollController = ScrollController();
  int _limit = 20;
  final int _limitIncrement = 20;

  List<QueryDocumentSnapshot> listMessage = new List.from([]);

  _scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent && !listScrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <= listScrollController.position.minScrollExtent && !listScrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    getContact();
  }

  Future<void> getContact() async {
    FirebaseFirestore.instance.collection('rooms').get().then((value) {
      value.docs.forEach((element) {
        if ((element.data()["member"][0] == widget.id || element.data()["member"][0] == widget.peerID) && (element.data()["member"][1] == widget.id || element.data()["member"][1] == widget.peerID)) {
          setState(() {
            roomId = element.id;
            isLoading = false;
            return;
          });
        } else {
          setState(() {
            roomId = "";
          });
        }
      });
      setState(() {
        isLoading = false;
      });
    }).catchError((ex, stracke) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: !isLoading
          ? Stack(
              children: [
                Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("messages").where('room_id', isEqualTo: roomId).orderBy("created_at", descending: true).snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
                            } else {
                              listMessage.addAll(snapshot.data.documents);
                              return ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.all(10.0),
                                itemBuilder: (context, index) {
                                  return MessageItem(
                                    index: index,
                                    document: snapshot.data.documents[index],
                                    id: widget.id,
                                    perAvatar: widget.perAvatar,
                                    listMessage: listMessage,
                                  );
                                },
                                itemCount: snapshot.data.documents.length,
                                reverse: true,
                                controller: listScrollController,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    MessageInput(roomId: roomId, peerId: widget.peerID, id: widget.id, peerAvatar: widget.perAvatar),
                  ],
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
