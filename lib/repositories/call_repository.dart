

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_snap_chat/constant/consts.dart';
import 'package:flutter_snap_chat/models/call_model.dart';
import 'package:flutter_snap_chat/utils/firebase_collection.dart';

class CallRepository{
  final CollectionReference callCollection =
  FirebaseFirestore.instance.collection(CALL_COLLECTION);

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.doc(uid).snapshots();

  Future<bool> makeCall({CallModel call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      print("callerid: "+ call.callerId);
      print("receiverid: "+call.receiverId);
      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({CallModel call,String log}) async {
    try {
      await FirebaseCollection().messageCollection.add({
        "content": log + "-"+call.receiverName,
        "created_at": DateTime.now().microsecondsSinceEpoch.toString(),
        "file": null,
        "image": null,
        "room_id": call.roomId,
        "sender_id": call.callerId,
        "type": "3",
      });

      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}