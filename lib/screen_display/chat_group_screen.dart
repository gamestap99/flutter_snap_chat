

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/chat_group_bloc/chat_group_cubit.dart';
import 'package:flutter_snap_chat/blocs/chat_group_bloc/chat_group_state.dart';
import 'package:flutter_snap_chat/const.dart';
import 'package:flutter_snap_chat/home.dart';
import 'package:flutter_snap_chat/models/room_model.dart';
import 'package:flutter_snap_chat/models/user_model.dart';
import 'package:flutter_snap_chat/widget/full_photo.dart';
import 'package:flutter_snap_chat/widget/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatGroupScreen extends StatefulWidget {
  final RoomModel roomModel;
  final String uid;
  const ChatGroupScreen({Key key,@required this.roomModel,@required this.uid}) : super(key: key);
  @override
  _ChatGroupScreenState createState() => _ChatGroupScreenState();
}

class _ChatGroupScreenState extends State<ChatGroupScreen> {

  String userName;
  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId;
  List<UserModel> users=[];
  String roomID;
  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;
  String firebaseCloudserverToken = 'AAAAhj567Ig:APA91bHwag-nBmArpNNk1IFc49sNtcGrjKggw5aKh7inosLqx4__qfMhMqHrPb7qvXu0utL6FGHP1nS9n4tMNiHdBml6YnWnzBzrXXubKT7gRCFwPlH3fSIalMHY0Nk9WPws3RORgh1N';
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

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
    super.initState();

    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);

    print("romid+000000-----------------: " + roomID.toString());
    isLoading = false;
    isShowSticker = false;
    imageUrl = '';


  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    // final metadata = firebase_storage.SettableMetadata(
    //     contentType: 'image/jpeg',
    //     customMetadata: {'picked-file-path': imageFile.path});
    await ref.putFile(imageFile);
    // uploadTask.then(() => )
    // ref.getDownloadURL();
    var link = await ref.getDownloadURL();
    print(link);
    setState(() {
      isLoading = false;
      onSendMessage("Đã gửi một ảnh", 1, image: link);
    });
    // firebase_storage.TaskSnapshot storageTaskSnapshot =  uploadTask.snapshot;
    // storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
    //   imageUrl = downloadUrl;
    //   setState(() {
    //     isLoading = false;
    //     onSendMessage(imageUrl, 1);
    //   });
    // }, onError: (err) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   Fluttertoast.showToast(msg: 'This file is not an image');
    // });
  }

  void onSendMessage(String content, int type, {File file, String image}) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();
      if (roomID == null) {
        CollectionReference messages = FirebaseFirestore.instance.collection('messages');
        CollectionReference documentReference = FirebaseFirestore.instance.collection('rooms');
        documentReference.add({
          'last_message': content,
          'member': widget.roomModel.member,
          'name': "",
          "roomImage": "",
          'type': "0",
        }).then((value) {
          messages.add({
            "content": content,
            "created_at": DateTime.now().microsecondsSinceEpoch.toString(),
            "file": file,
            "image": image,
            "room_id": value.id,
            "sender_id": widget.uid,
            "type": type.toString(),
          });
          setState(() {
            roomID = value.id;
          });
        });
        listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      } else {
        CollectionReference messages = FirebaseFirestore.instance.collection('messages');
        CollectionReference documentReference = FirebaseFirestore.instance.collection('rooms');
        documentReference.doc(roomID).update({
          'last_message': content,
        }).then((value) {
          messages.add({
            "content": content,
            "created_at": DateTime.now().microsecondsSinceEpoch.toString(),
            "file": file,
            "image": image,
            "room_id": roomID,
            "sender_id": widget.uid,
            "type": type.toString(),
          });
        });
      }
      users.forEach((element) {
        if(element.id != widget.uid){
          sendNotificationMessageToPeerUser("1", type.toString(), content, userName, widget.roomModel.id, element.fcmToken);
        }
      });

    } else {
      Fluttertoast.showToast(msg: 'Asss', backgroundColor: Colors.black, textColor: Colors.red);
    }
  }

  Future<void> sendNotificationMessageToPeerUser(unReadMSGCount, messageType, textFromTextField, myName, chatID, peerUserToken) async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    try {
      await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$firebaseCloudserverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': messageType == '0'
                  ? '$textFromTextField'
                  : messageType == '1'
                  ? 'imagw'
                  : 'ticker',
              'title': '$myName',
              'badge': '$unReadMSGCount', //'$unReadMSGCount'
              "sound": "default"
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'chatroomid': chatID,
            },
            'to': peerUserToken,
          },
        ),
      );
    } catch (ex) {
      print("error post:" + ex.toString());
    }
    final Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );
  }

  Widget buildItem(int index, DocumentSnapshot document, List<UserModel> users) {
    if (document.data()['sender_id'] == widget.uid) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document.data()['type'] == "0"
          // Text
              ? Container(
            child: Text(
              document.data()['content'],
              style: TextStyle(color: primaryColor),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(color: greyColor2, borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )
              : document.data()['type'] == "1"
              ?
          // Image
          Container(
            child: FlatButton(
              child: Material(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                    ),
                    width: 200.0,
                    height: 200.0,
                    padding: EdgeInsets.all(70.0),
                    decoration: BoxDecoration(
                      color: greyColor2,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Material(
                    child: Image.asset(
                      'assets/img_not_available.jpeg',
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  imageUrl: document.data()['image'],
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                clipBehavior: Clip.hardEdge,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FullPhoto(url: document.data()['content'])));
              },
              padding: EdgeInsets.all(0),
            ),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )
              : Container(
            child: Image.asset(
              'assets/${document.data()['image']}.gif',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          ),
          // Sticker,
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      UserModel user;
      users.forEach((element) {
        if (element.id == document.data()['sender_id']) {
          user = element;
        }
      });

      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                      width: 35.0,
                      height: 35.0,
                      padding: EdgeInsets.all(10.0),
                    ),
                    imageUrl: user.photo,
                    width: 35.0,
                    height: 35.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                document.data()['type'] == "0"
                    ? Container(
                  child: Text(
                    document.data()['content'],
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : document.data()['type'] == "1"
                    ? Container(
                  child: FlatButton(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                          ),
                          width: 200.0,
                          height: 200.0,
                          padding: EdgeInsets.all(70.0),
                          decoration: BoxDecoration(
                            color: greyColor2,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Material(
                          child: Image.asset(
                            'assets/img_not_available.jpeg',
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        ),
                        imageUrl: document.data()['image'],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FullPhoto(url: document.data()['content'])));
                    },
                    padding: EdgeInsets.all(0),
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : Container(
                  child: Image.asset(
                    'assets/${document.data()['image']}.gif',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
                ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(document.data()['created_at']))),
                style: TextStyle(color: greyColor, fontSize: 12.0, fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1].data()['idFrom'] == widget.uid) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1].data()['idFrom'] != widget.uid) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  List<Choice> choices = const <Choice>[

    const Choice(title: 'Rời nhóm', icon: Icons.exit_to_app),
  ];
  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Rời nhóm') {
      List<String> member = widget.roomModel.member;
      member.remove(widget.uid);
      FirebaseFirestore.instance.collection('rooms').doc(widget.roomModel.id)
          .update({
        'member':member,
      }).then((value) => Navigator.of(context).pop());
    } else {

    }
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            widget.roomModel.photo != null
                 ? Material(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                  ),
                  width: 35.0,
                  height: 35.0,
                  padding: EdgeInsets.all(10.0),
                ),
                imageUrl: widget.roomModel.photo,
                width: 35.0,
                height: 35.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(18.0),
              ),
              clipBehavior: Clip.hardEdge,
            )
            :Material(
              child: Image.asset("assets/no_avatar.jpg",width: 35,height: 35,),
              borderRadius: BorderRadius.all(
                Radius.circular(18.0),
              ),
              clipBehavior: Clip.hardEdge,
            ),
            SizedBox(
              width: 5,
            ),
            Text(widget.roomModel.name),
          ],
        ),
        actions: [
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          choice.icon,
                          color: primaryColor,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                          style: TextStyle(color: primaryColor),
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body: BlocConsumer<ChatGroupCubit, ChatGroupState>(
          builder: (context, state) {
            if (state is ChatGroupLoading) {
              return Container();
            } else if (state is ChatGroupLoaded) {
              return WillPopScope(
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        // List of messages
                        buildListMessage(state.users),

                        // Sticker
                        (isShowSticker ? buildSticker() : Container()),

                        // Input content
                        buildInput(),
                      ],
                    ),

                    // Loading
                    buildLoading()
                  ],
                ),
                onWillPop: onBackPress,
              );
            }
            return Container();
          },
          listener: (context, state) {}),
    );
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('Đã gửi một Sticker', 2, image: 'mimi1'),
                child: Image.asset(
                  'assets/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('Đã gửi một Sticker', 2, image: 'mimi2'),
                child: Image.asset(
                  'assets/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('Đã gửi một Sticker', 2, image: 'mimi3'),
                child: Image.asset(
                  'assets/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('Đã gửi một Sticker', 2, image: 'mimi4'),
                child: Image.asset(
                  'assets/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('Đã gửi một Sticker', 2, image: 'mimi5'),
                child: Image.asset(
                  'assets/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('Đã gửi một Sticker', 2, image: 'mimi6'),
                child: Image.asset(
                  'assets/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('Đã gửi một Sticker', 2, image: 'mimi7'),
                child: Image.asset(
                  'assets/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('Đã gửi một Sticker', 2, image: 'mimi8'),
                child: Image.asset(
                  'assets/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('Đã gửi một Sticker', 2, image: 'mimi9'),
                child: Image.asset(
                  'assets/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: greyColor2, width: 0.5)), color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text, 0);
                },
                style: TextStyle(color: primaryColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(border: Border(top: BorderSide(color: greyColor2, width: 0.5)), color: Colors.white),
    );
  }

  Widget buildListMessage(List<UserModel> users) {
    return Flexible(
      child: groupChatId == ''
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
        stream: FirebaseFirestore.instance.collection('messages').where('room_id', isEqualTo: widget.roomModel.id).orderBy("created_at", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
          } else {
            listMessage.addAll(snapshot.data.documents);
            print("data" + listMessage.length.toString());
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) {
                return buildItem(index, snapshot.data.documents[index], users);
              },
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }
}
