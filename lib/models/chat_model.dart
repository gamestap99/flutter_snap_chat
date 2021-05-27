import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ChatModel extends Equatable {
  const ChatModel({
    @required this.content,
    @required this.createdAt,
    @required this.roomId,
    @required this.file,
    @required this.senderId,
    @required this.type,
  })  : assert(content != null),
        assert(createdAt != null),
        assert(roomId != null),
        assert(senderId != null);

  final String content;
  final String createdAt;
  final String file;
  final String roomId;
  final String senderId;
  final String type;

  @override
  // TODO: implement props
  List<Object> get props => [content, createdAt, file, roomId, senderId, type];
}
