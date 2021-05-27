import 'package:equatable/equatable.dart';

class RobotModel extends Equatable {
  final String text;
  final String recipientId;

  RobotModel({this.text, this.recipientId});

  factory RobotModel.fromJson(Map<String, dynamic> json) => RobotModel(
        text: json["text"],
        recipientId: json["recipient_id"],
      );

  @override
  // TODO: implement props
  List<Object> get props => [text, recipientId];
}
