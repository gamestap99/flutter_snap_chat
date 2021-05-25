import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UserModel extends Equatable {
  const UserModel({
    @required this.id,
    @required this.name,
    @required this.photo,
    @required this.fcmToken,
    @required this.status,
  }) : assert(id != null);

  /// The current user's email address.

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String name;

  /// Url for the current user's photo.
  final String photo;

  final String fcmToken;
  final String status;

  /// Empty user which represents an unauthenticated user.
  static const empty = UserModel(id: '', name: null, photo: null, fcmToken: null, status: null);

  UserModel.fromSnapShot(DocumentSnapshot documentSnapshot)
      : id = documentSnapshot.id,
        name = documentSnapshot.data()['nickname'],
        photo = documentSnapshot.data()['photoUrl'],
        status = documentSnapshot.data()['status'],
        fcmToken = documentSnapshot.data()['pushToken'];


  @override
  List<Object> get props => [id, name, photo, fcmToken, status];
}
