import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/models/call_model.dart';
import 'package:flutter_snap_chat/repositories/call_repository.dart';
import 'package:flutter_snap_chat/screen_display/callscreens/pickup/pickup_screen.dart';
import 'package:provider/provider.dart';


class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallRepository callMethods = CallRepository();

  PickupLayout({
    @required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    var    _uid ;
    try{
      _uid = context
          .select((FriendProviderCubit bloc) => bloc.state.userModel.id.toString());

    }catch(ex){
      print("uid pickup: " +ex);
    }



    return (_uid != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid:_uid),
            builder: (context, snapshot) {

              if (snapshot.hasData && snapshot.data != null && snapshot.data.data() != null) {

                CallModel call = CallModel.fromMap(snapshot.data.data());

                if (!call.hasDialled) {
                  return PickupScreen(call: call);
                }
              }
              return scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
