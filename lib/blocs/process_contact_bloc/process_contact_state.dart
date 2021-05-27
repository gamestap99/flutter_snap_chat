import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/contact_model.dart';

abstract class ProcessContactState extends Equatable {}

class ProcessContactLoading extends ProcessContactState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ProcessContactLoaded extends ProcessContactState {
  final String contactId;
  final ContactModel contactModel;

  ProcessContactLoaded({this.contactId, this.contactModel});

  @override
  // TODO: implement props
  List<Object> get props => [contactId, contactModel];
}

class ProcessContactLoadFailure extends ProcessContactState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
