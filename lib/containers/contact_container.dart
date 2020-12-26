import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/contact_bloc/bloc.dart';
import 'package:flutter_snap_chat/repositories/contact_repository.dart';
import 'package:flutter_snap_chat/screen_display/contact_display_screen.dart';

class ContactContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactCubit(ApiContactRepository()),
      child: ContactDisplayScreen(),
    );
  }
}
