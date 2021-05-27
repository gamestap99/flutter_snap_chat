import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UserModel extends Equatable {
  const UserModel({
    @required this.id,
    @required this.name,
    @required this.avatar,
    @required this.fcmToken,
    @required this.status,
    @required this.background,
  }) : assert(id != null);

  final String id;
  final String name;
  final String avatar;
  final String fcmToken;
  final String status;
  final String background;

  /// Empty user which represents an unauthenticated user.
  static const empty = UserModel(id: '', name: null, avatar: null, fcmToken: null, status: null, background: null);

  UserModel.fromSnapShot(DocumentSnapshot documentSnapshot)
      : id = documentSnapshot.id,
        name = documentSnapshot.data()['nickname'],
        avatar = documentSnapshot.data()['avatar'],
        background = documentSnapshot.data()['background'],
        status = documentSnapshot.data()['status'],
        fcmToken = documentSnapshot.data()['pushToken'];

  @override
  List<Object> get props => [id, name, avatar, fcmToken, status, background];
}
