

import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/database/user.dart';
import 'package:meta/meta.dart';

class UserModel extends Equatable{
  const UserModel({
    @required this.id,
    @required this.name,
    @required this.photo,
    @required this.fcmToken,
  })  :
        assert(id != null);

  /// The current user's email address.

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String name;

  /// Url for the current user's photo.
  final String photo;

  final String fcmToken;

  /// Empty user which represents an unauthenticated user.
  static const empty = UserModel( id: '', name: null, photo: null,fcmToken:null );


  @override
  List<Object> get props => [ id, name, photo,fcmToken];
}