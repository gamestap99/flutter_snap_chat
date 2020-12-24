import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/contact_model.dart';

abstract class ProcessContactEvent extends Equatable {}

class ProcessContactGetContactId extends ProcessContactEvent {
  final String uid;
  final String peerId;

  ProcessContactGetContactId(this.uid, this.peerId);

  @override
  // TODO: implement props
  List<Object> get props => [uid, peerId];
}

class ProcessContactDataChanged extends ProcessContactEvent {
  final ContactModel contactModel;

  ProcessContactDataChanged(this.contactModel);

  @override
  // TODO: implement props
  List<Object> get props => [contactModel];
}

class ProcessContactAddContact extends ProcessContactEvent {
  final String uid;
  final String peerId;

  ProcessContactAddContact(this.uid, this.peerId);

  @override
  // TODO: implement props
  List<Object> get props => [uid, peerId];
}
class ProcessContactDeleteContact extends ProcessContactEvent{
  final String contactId;

  ProcessContactDeleteContact(this.contactId);
  @override
  // TODO: implement props
  List<Object> get props => [contactId];

}
class ProcessContactAcpectContact extends ProcessContactEvent{
  final String contactId;

  ProcessContactAcpectContact(this.contactId);
  @override
  // TODO: implement props
  List<Object> get props => [contactId];

}
class ProcessContactAddContactById extends ProcessContactEvent{
  final String contactId;

  ProcessContactAddContactById(this.contactId);
  @override
  // TODO: implement props
  List<Object> get props => [contactId];

}