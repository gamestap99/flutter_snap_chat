import 'package:flutter_snap_chat/models/user_model.dart';

abstract class ChatRepository {
  Future<List<UserModel>> getUsers(List<String> members, String uid);
}

class ApiChatRepository implements ChatRepository {
  @override
  Future<List<UserModel>> getUsers(List<String> members, String uid) {
    for (String value in members) {
      if (value != uid) {}
    }
  }
}
