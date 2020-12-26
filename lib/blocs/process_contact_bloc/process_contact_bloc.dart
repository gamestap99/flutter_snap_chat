import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/process_contact_bloc/process_contact_event.dart';
import 'package:flutter_snap_chat/blocs/process_contact_bloc/process_contact_state.dart';
import 'package:flutter_snap_chat/models/contact_model.dart';
import 'package:flutter_snap_chat/repositories/contact_repository.dart';

class ProcessContactBloc extends Bloc<ProcessContactEvent, ProcessContactState> {
  ProcessContactBloc(this._contactRepository)
      : assert(_contactRepository != null),
        super(ProcessContactLoading());
  final ContactRepository _contactRepository;
  StreamSubscription<ContactModel> _streamSubscription;
  @override
  Stream<ProcessContactState> mapEventToState(ProcessContactEvent event)async* {
    try{
      if(event is ProcessContactGetContactId){
        final contactId =await _contactRepository.getContactId(event.uid, event.peerId);
        _streamSubscription = _contactRepository.contact(contactId).listen((event) {
          add(ProcessContactDataChanged(event));
        });
      }else if(event is ProcessContactDataChanged){
        yield ProcessContactLoaded(contactModel: event.contactModel);
      }else if(event is ProcessContactAddContact){
        final newContactId =await _contactRepository.addContact(event.uid, event.peerId, "1");
        _streamSubscription = _contactRepository.contact(newContactId).listen((event) {
          add(ProcessContactDataChanged(event));
        });
      }else if(event is ProcessContactAcpectContact ){
        await _contactRepository.acpectContact(event.contactId);
      }else if(event is ProcessContactDeleteContact){
        await _contactRepository.deleteContact(event.contactId);
      }else if(event is ProcessContactAddContactById){
        await _contactRepository.addContactById(event.contactId);
      }
    }catch(ex){
      yield ProcessContactLoadFailure();
    }
  }
  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
