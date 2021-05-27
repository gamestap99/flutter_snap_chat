import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class UserDB {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String photoUrl;

  UserDB(this.id, this.name, this.photoUrl);
}
