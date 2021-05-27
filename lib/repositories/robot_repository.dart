import 'dart:convert';

import 'package:flutter_snap_chat/constant/consts.dart';
import 'package:flutter_snap_chat/models/robot_model.dart';
import 'package:http/http.dart' as http;

abstract class RobotRepository {
  Future<List<dynamic>> contactBot(String sender, String message);
}

class ApiRobotRepository implements RobotRepository {
  @override
  Future<List<dynamic>> contactBot(String sender, String message) async {
    var response = await http.post(
      urlContactBot,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sender': sender,
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).map((e) => RobotModel.fromJson(e)).toList();
    } else {
      throw Exception('Khong ket noi toi duoc bot');
    }
  }
}
