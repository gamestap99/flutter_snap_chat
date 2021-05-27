import 'package:equatable/equatable.dart';

enum BotRender { idle, loading, loaded, error }

class BotState extends Equatable {
  final List<dynamic> listMessage;
  final BotRender botRender;

  BotState({
    this.listMessage,
    this.botRender,
  });

  factory BotState.initial() => BotState(
        listMessage: const [],
        botRender: BotRender.idle,
      );

  BotState coppyWith({
    listMessage,
    botRender,
  }) {
    return BotState(
      listMessage: listMessage ?? this.listMessage,
      botRender: botRender ?? this.botRender,
    );
  }

  @override
  List<Object> get props => [listMessage, botRender];
}
