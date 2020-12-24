import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_snap_chat/models/room_model.dart';

abstract class RoomRepository {
  Future<List<RoomModel>> getRoom(String uid);
}

class ApiRoomRepository implements RoomRepository {
  @override
  Future<List<RoomModel>> getRoom(String uid) async {
    // TODO: implement getRoo
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('rooms').where('member', arrayContainsAny: [uid]).get();
    final rooms= List<RoomModel>.of(
      snapshot.docs.map<RoomModel>((e) =>  RoomModel(id: e.id,
          name: e.data()['name'],
          message: e.data()['last_message'],
          photo: e.data()['roomImage'],
          type: e.data()['type'],
          member: List<String>.from(e.data()['member'])))
    );
    // print(rooms.length);
    // print(rooms.elementAt(0).id);
    return rooms;
  }

}