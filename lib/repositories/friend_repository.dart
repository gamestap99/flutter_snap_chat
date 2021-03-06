import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_snap_chat/models/contact_model.dart';
import 'package:flutter_snap_chat/models/friend_model.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

abstract class FriendRepository {
  Stream<List<ContactModel>> friends(String uid);

  List<String> getIdFriends(List<ContactModel> items, String uid);

  Future<UserModel> getUser(String uid);

  Future<List<UserModel>> getUsers(
    List<String> uids,
  );

  Stream<int> getCountAcpectFriend(String uid);

  Stream<List<ContactModel>> getAllApectContact(String uid);
}

class ApiFriendRepository implements FriendRepository {
  @override
  Stream<FriendModel> users(String uid) {
    return FirebaseFirestore.instance.collection("users").doc(uid).snapshots().map((event) {
      return !event.exists ? FriendModel.empty : FriendModel(friends: event.data()['friends']);
    });
  }

  @override
  List<String> getIdFriends(List<ContactModel> items, String uid) {
    // TODO: implement getFriends
    List<String> users = [];
    // friendModel.friends.forEach((key, value) async {
    //   if (value.toString() == "1") {
    //     users.add(key.toString().trim());
    //   }
    // });
    print("test----");
    print(items.toString());

    items.forEach((element) {
      if (element.senderId == uid) {
        users.add(element.receiverId);
      } else {
        users.add(element.senderId);
      }
    });
    return users;
  }

  @override
  Future<UserModel> getUser(String uid) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return UserModel(
      id: snapshot.id,
      name: snapshot.data()['nickname'],
      avatar: snapshot.data()['avatar'],
      fcmToken: snapshot.data().containsKey('pushToken') ? snapshot.data()['pushToken'] : null,
      status: snapshot.data()['status'],
      background: snapshot.data()['background'],
    );
  }

  @override
  Future<List<UserModel>> getUsers(List<String> uids) async {
    List<UserModel> users = [];

    for (String id in uids) {
      print("id: " + id);
      UserModel userModel = await getUser(id);
      print(userModel.toString());
      users.add(userModel);
    }
    return Future.value(users);
  }

  @override
  Stream<int> getCountAcpectFriend(String uid) {
    print("uid: " + uid);
    return FirebaseFirestore.instance.collection('contacts').where("receiverId", isEqualTo: uid).where("status", isEqualTo: "1").snapshots().map((event) {
      return event.docs.length;
    });
  }

  @override
  Stream<List<ContactModel>> getAllApectContact(String uid) {
    return FirebaseFirestore.instance.collection('contacts').where("receiverId", isEqualTo: uid).where("status", isEqualTo: "1").snapshots().map((event) {
      return event.docs.length > 0 ? List<ContactModel>.from(event.docs.map((e) => ContactModel.fromSnapShot(e)).toList()) : List<ContactModel>.from([]);
    });
  }

  @override
  Stream<List<ContactModel>> friends(String uid) {
    return FirebaseFirestore.instance.collection('contacts').where('merge', arrayContainsAny: [uid]).where("status", isEqualTo: "0").snapshots().map((event) {
          return event.docs.length > 0 ? List<ContactModel>.from(event.docs.map((e) => ContactModel.fromSnapShot(e)).toList()) : List<ContactModel>.from([]);
        });
  }
}
