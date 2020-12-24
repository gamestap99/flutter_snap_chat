import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_snap_chat/models/contact_model.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

abstract class ContactRepository {
  Future<List<UserModel>> getUsers();
  Future<List<UserModel>> searchUsers(String name);
  Future<String> addContact(String uId, String peerId, String status);

  Stream<ContactModel> contact(String contactId);

  Future<String> getContactId(String uid,String peerId);

  Future<void> acpectContact(String contactId);
  Future<void> deleteContact(String contactId);
  Future<void> addContactById(String contactId);
}

class ApiContactRepository implements ContactRepository {
  @override
  Future<List<UserModel>> getUsers() async {
    // TODO: implement getUsers
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
    final users = List<UserModel>.of(
      snapshot.docs.map(
        (e) => UserModel(
          id: e.id,
          name: e.data()['nickname'],
          photo: e.data()['photoUrl'],
        ),
      ),
    );
    return users;
  }

  @override
  Future<String> addContact(String uId, String peerId, String status) async {
    try {
     DocumentReference reference = await FirebaseFirestore.instance.collection('contacts').add({
        'senderId': uId,
        'receiveId': peerId,
        'status': status,
        'created_at': DateTime.now().toString(),
      });
     return reference.id;
    } catch (ex) {
      throw Exception('Add contact thất bại!');
      return null;
    }
  }

  @override
  Stream<ContactModel> contact(String contactId) {
    return FirebaseFirestore.instance.collection("contacts").doc(contactId).snapshots().map((event) {
      return !event.exists ? ContactModel.empty : ContactModel.fromSnapShot(event);
    });
  }

  @override
  Future<String> getContactId(String uid, String peerId) async {
    QuerySnapshot snapshot =  await  FirebaseFirestore.instance.collection('contacts').where('senderId',whereIn:[uid,peerId]).get();
    String contactId;
    if(snapshot.docs.length > 0){
      snapshot.docs.forEach((element) {
        if(element['senderId'] == uid && element['receiveId'] == peerId ||element['senderId'] == peerId && element['receiveId'] ==uid ){
          // setState(() {
          //   contactId = element.id;
          //   print("contactId: " +contactId.toString());
          // });
          contactId=element.id;
        }
      });
      return contactId;
    }else{
      return contactId;
    }
  }

  @override
  Future<void> acpectContact(String contactId) {
    FirebaseFirestore.instance.collection('contacts')
        .doc(contactId)
        .update({'status': "0"})
        .then((value) {})
        .catchError((ex){throw Exception('acpectContact contact that bai');});
  }

  @override
  Future<void> addContactById(String contactId) {
    FirebaseFirestore.instance.collection('contacts')
        .doc(contactId)
        .update({'status': "1"})
        .then((value) {})
        .catchError((ex){throw Exception('addContactById contact that bai');});
  }

  @override
  Future<void> deleteContact(String contactId) {
      FirebaseFirestore.instance.collection('contacts')
          .doc(contactId)
          .update({'status': "-1"})
          .then((value) {})
          .catchError((ex){throw Exception('Delete contact that bai');});

  }

  @override
  Future<List<UserModel>> searchUsers(String name) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users')
        .get();
    final users = List<UserModel>.of(
      snapshot.docs.map(
            (e) => UserModel(
          id: e.id,
          name: e.data()['nickname'],
          photo: e.data()['photoUrl'],
        ),
      ),
    );
    var startUsers = users.where((element) => element.name.toLowerCase().startsWith(name.toLowerCase())).toList();
    var usersContain = users.where((element) => !element.name.toLowerCase().startsWith(name.toLowerCase()) &&
        element.name.toLowerCase().contains(name.toLowerCase())).toList();
    return startUsers +usersContain;
  }
}
