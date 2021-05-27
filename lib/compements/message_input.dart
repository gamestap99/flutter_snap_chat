import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/constant/app_color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class MessageInput extends StatefulWidget {
  final String roomId;
  final String peerId;
  final String id;
  final String peerAvatar;

  const MessageInput({Key key, @required this.roomId, @required this.peerId, @required this.id, @required this.peerAvatar}) : super(key: key);

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  int _limit = 20;
  final int _limitIncrement = 20;
  final FocusNode focusNode = FocusNode();
  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

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
    listScrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
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

  void onSendMessage(String content, int type, {File file}) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();
      if (widget.roomId == null) {
        print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        CollectionReference messages = FirebaseFirestore.instance.collection('messages');
        CollectionReference documentReference = FirebaseFirestore.instance.collection('rooms');
        documentReference.add({
          'last_message': content,
          'member': [
            widget.peerId,
            widget.id,
          ],
          'name': "",
          "roomImage": widget.peerAvatar,
          'type': 1,
        }).then((value) {
          messages.add({
            "content": content,
            "created_at": DateTime.now().microsecondsSinceEpoch,
            "file": file,
            "room_id": value.id,
            "sender_id": widget.id,
          });

          // FirebaseFirestore.instance.collection('users').doc(widget.id).update({
          //   'chattingWith':FieldValue.arrayUnion([{
          //     'peerId': widget.peerId,
          //     'roomId': value.id,
          //   }]),
          // });
        });
      } else {
        CollectionReference messages = FirebaseFirestore.instance.collection('messages');
        CollectionReference documentReference = FirebaseFirestore.instance.collection('rooms');
        documentReference.doc(widget.roomId).update({
          'last_message': content,
        }).then((value) {
          messages.add({
            "content": content,
            "created_at": DateTime.now().toString(),
            "file": file,
            "room_id": widget.roomId,
            "sender_id": widget.id,
          });
        });
      }
    } else {
      Fluttertoast.showToast(msg: 'Asss', backgroundColor: Colors.black, textColor: Colors.red);
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
      // uploadFile();
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }
// Future uploadFile() async {
//   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//   StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
//   StorageUploadTask uploadTask = reference.putFile(imageFile);
//   StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
//   storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
//     imageUrl = downloadUrl;
//     setState(() {
//       isLoading = false;
//       onSendMessage(imageUrl, 1);
//     });
//   }, onError: (err) {
//     setState(() {
//       isLoading = false;
//     });
//     Fluttertoast.showToast(msg: 'This file is not an image');
//   });
// }
}
