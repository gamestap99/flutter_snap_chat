import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/process_contact_bloc/process_contact_bloc.dart';
import 'package:flutter_snap_chat/blocs/process_contact_bloc/process_contact_event.dart';
import 'package:flutter_snap_chat/models/user_model.dart';
import 'package:flutter_snap_chat/repositories/contact_repository.dart';
import 'package:flutter_snap_chat/screen_display/profile_test.dart';

class ProfileContainer extends StatelessWidget {
  final String uid;
  final UserModel peerUser;

  const ProfileContainer({Key key,@required this.uid,@required this.peerUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProcessContactBloc(ApiContactRepository())..add(ProcessContactGetContactId(uid, peerUser.id)),
      child: ProfileTest(uid: uid,peerUser: peerUser,),
    );
  }
}
