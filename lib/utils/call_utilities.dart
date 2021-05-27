import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/models/call_model.dart';
import 'package:flutter_snap_chat/models/user_model.dart';
import 'package:flutter_snap_chat/repositories/call_repository.dart';
import 'package:flutter_snap_chat/screen_display/callscreens/call_screen.dart';

class CallUtils {
  static final CallRepository callMethods = CallRepository();

  static dial({UserModel from, UserModel to, context, String roomId}) async {
    CallModel call = CallModel(
      callerId: from.id,
      callerName: from.name,
      callerPic: from.avatar,
      receiverId: to.id,
      receiverName: to.name,
      receiverPic: to.avatar,
      roomId: roomId,
      channelId: Random().nextInt(1000).toString(),
    );

    // Log log = Log(
    //   callerName: from.name,
    //   callerPic: from.profilePhoto,
    //   callStatus: CALL_STATUS_DIALLED,
    //   receiverName: to.name,
    //   receiverPic: to.profilePhoto,
    //   timestamp: DateTime.now().toString(),
    // );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call),
        ),
      );
    }
  }
}
