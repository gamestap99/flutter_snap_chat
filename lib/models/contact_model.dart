import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ContactModel extends Equatable {
  final String contactId;
  final String senderId;
  final String receiverId;
  final String createdAt;
  final String status;

  ContactModel({
    @required this.contactId,
    @required this.senderId,
    @required this.receiverId,
    @required this.createdAt,
    @required this.status,
  });

  static var empty = ContactModel(contactId: null, senderId: null, receiverId: null, createdAt: null, status: null);

  ContactModel.fromSnapShot(DocumentSnapshot documentSnapshot)
      : contactId = documentSnapshot.id,
        senderId = documentSnapshot.data()['senderId'],
        receiverId = documentSnapshot.data()['receiverId'],
        status = documentSnapshot.data()['status'],
        createdAt = documentSnapshot.data()['created_at'];

  @override
  // TODO: implement props
  List<Object> get props => [contactId, senderId, receiverId, createdAt, status];
}
