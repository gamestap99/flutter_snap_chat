import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/bot_bloc/bot_state.dart';
import 'package:flutter_snap_chat/repositories/robot_repository.dart';

class BotCubit extends Cubit<BotState> {
  BotCubit(this._robotRepository) : super(BotState.initial());

  final RobotRepository _robotRepository;

  Future<void> onSendMessage(String message, String sender) async {
    emit(state.coppyWith(
      listMessage: List<dynamic>.from([message]) + state.listMessage,
      botRender: BotRender.loading,
    ));

    try {
      final data = await _robotRepository.contactBot(sender, message);

      emit(state.coppyWith(
        listMessage: List<dynamic>.from(data) + state.listMessage,
        botRender: BotRender.loaded,
      ));
    } catch (ex) {
      print("ex:");
      print(ex.toString());
      emit(state.coppyWith(
        botRender: BotRender.error,
      ));
    }
  }
}
