import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/bot_bloc/bot_cubit.dart';
import 'package:flutter_snap_chat/repositories/robot_repository.dart';
import 'package:flutter_snap_chat/screen_display/bot_screen.dart';

class BotContainer extends StatelessWidget {
  const BotContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BotCubit(ApiRobotRepository()),
      child: BotScreen(),
    );
  }
}
