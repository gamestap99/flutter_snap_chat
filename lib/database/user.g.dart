// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

import 'package:flutter_snap_chat/database/user.dart';
import 'package:hive/hive.dart';

class UserAdapter extends TypeAdapter<UserDB> {
  @override
  final typeId = 0;

  @override
  UserDB read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDB(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserDB obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..write(2)
      ..write(obj.photoUrl);
  }
}
