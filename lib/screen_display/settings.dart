import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/constant/app_color.dart';
import 'package:flutter_snap_chat/router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông tin hiển thị',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  State createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  TextEditingController controllerNickname;
  TextEditingController controllerAboutMe;

  SharedPreferences prefs;

  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';
  String uid;
  bool isLoading = false;
  File avatarImageFile;

  final FocusNode focusNodeNickname = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if(pickedFile.path != null){
      File image = File(pickedFile.path);

      if (image != null) {
        setState(() {
          avatarImageFile = image;
          isLoading = true;
        });
      }
      uploadFile();
    }


  }

  Future uploadFile() async {
    String fileName = uid;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    // final metadata = firebase_storage.SettableMetadata(
    //     contentType: 'image/jpeg',
    //     customMetadata: {'picked-file-path': imageFile.path});
    await ref.putFile(avatarImageFile);
    // uploadTask.then(() => )
    // ref.getDownloadURL();
    photoUrl = await ref.getDownloadURL();
    FirebaseFirestore.instance.collection('users').doc(uid).update({'nickname': nickname, 'aboutMe': aboutMe, 'photoUrl': photoUrl}).then((data) async {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Upload success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      print("error:" + err.toString());
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void handleUpdateData() {
    focusNodeNickname.unfocus();
    focusNodeAboutMe.unfocus();
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'nickname': nickname,
      'aboutMe': aboutMe,
      'photoUrl': photoUrl == null || photoUrl.length == 0 ? "https://firebasestorage.googleapis.com/v0/b/snapchat-ac0cf.appspot.com/o/no_avatar.jpg?alt=media&token=55c6ff85-2ed4-4f74-b067-8e08a15b43bc" : photoUrl,
    }).then((data) async {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Update success");
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.control, (route) => false, arguments: {
        "userId": uid,
      });
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    uid = context.select((AuthenticationBloc bloc) => bloc.state.user.id.toString());
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                // Avatar
                Container(
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        (avatarImageFile == null)
                            ? (photoUrl != ''
                                ? Material(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                                        ),
                                        width: 90.0,
                                        height: 90.0,
                                        padding: EdgeInsets.all(20.0),
                                      ),
                                      imageUrl: photoUrl,
                                      width: 90.0,
                                      height: 90.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(45.0)),
                                    clipBehavior: Clip.hardEdge,
                                  )
                                : Icon(
                                    Icons.account_circle,
                                    size: 90.0,
                                    color: greyColor,
                                  ))
                            : Material(
                                child: Image.file(
                                  avatarImageFile,
                                  width: 90.0,
                                  height: 90.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(45.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: primaryColor.withOpacity(0.5),
                          ),
                          onPressed: getImage,
                          padding: EdgeInsets.all(30.0),
                          splashColor: Colors.transparent,
                          highlightColor: greyColor,
                          iconSize: 30.0,
                        ),
                      ],
                    ),
                  ),
                  width: double.infinity,
                  margin: EdgeInsets.all(20.0),
                ),

                // Input
                Column(
                  children: <Widget>[
                    // Username
                    Container(
                      child: Text(
                        'Tên hiển thị',
                        style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                      margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                    ),
                    Container(
                      child: Theme(
                        data: Theme.of(context).copyWith(primaryColor: primaryColor),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Nam Dv',
                            contentPadding: EdgeInsets.all(5.0),
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          controller: controllerNickname,
                          onChanged: (value) {
                            nickname = value;
                          },
                          // focusNode: focusNodeNickname,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),

                    // About me
                    Container(
                      child: Text(
                        'Giới thiệu bản thân',
                        style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                      margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                    ),
                    Container(
                      child: Theme(
                        data: Theme.of(context).copyWith(primaryColor: primaryColor),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Tôi là dev mobile, sử dụng Flutter',
                            contentPadding: EdgeInsets.all(5.0),
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          // controller: controllerAboutMe,
                          onChanged: (value) {
                            aboutMe = value;
                          },
                          focusNode: focusNodeAboutMe,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),

                // Button
                Container(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    onPressed: handleUpdateData,
                    child: Text(
                      'Xác nhận',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    color: primaryColor,
                    highlightColor: Color(0xff8d93a0),
                    splashColor: Colors.transparent,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                  ),
                  margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
                ),
              ],
            ),
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),

        // Loading
        Positioned(
          child: isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
                  ),
                  color: Colors.white.withOpacity(0.8),
                )
              : Container(),
        ),
      ],
    );
  }
}
