
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_snap_chat/constant/consts.dart';
class FirebaseCollection{
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;



  CollectionReference get userCollection=> _fireStore.collection(USERS_COLLECTION);
  CollectionReference get messageCollection=> _fireStore.collection(MESSAGES_COLLECTION);
}