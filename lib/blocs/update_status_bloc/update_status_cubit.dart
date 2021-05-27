import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/update_status_bloc/update_status_state.dart';

class UpdateStatusCubit extends Cubit<UpdateStatusState> {
  UpdateStatusCubit(UpdateStatusState state) : super(state);

  void updateStatus(String uid) {
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'status': "0",
    });
  }
}
