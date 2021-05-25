import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_snap_chat/models/room_model.dart';

abstract class RoomRepository {
  Stream<List<RoomModel>> getRoom(String uid);
}

class ApiRoomRepository implements RoomRepository {
  @override
  Stream<List<RoomModel>> getRoom(String uid) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .where('member', arrayContainsAny: [uid])
        .snapshots()
        .map((event) {
          return event.docs.length == 0
              ? List<RoomModel>.from([])
              : event.docs
                  .map((e) => RoomModel(
                        id: e.id,
                        name: e.data()["name"],
                        message: e.data()["last_message"],
                        photo: e.data()['roomImage'],
                        type: e.data()["type"],
                        member: List<String>.from(e.data()["member"]),
                        createdAt: e.data()["created_at"],
                      ))
                  .toList();
        });
  }
}
