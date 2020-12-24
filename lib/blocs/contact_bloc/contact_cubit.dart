

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/contact_bloc/bloc.dart';
import 'package:flutter_snap_chat/repositories/contact_repository.dart';

class ContactCubit extends Cubit<ContactState>{
  final ContactRepository repository;
  ContactCubit(this.repository) : super(ContactLoading()){
    getUsers();
  }
  Future<void> getUsers() async {
    try{
      final users =await repository.getUsers();
      emit(ContactLoaded(users));
    }catch(e){
      emit(ContactLoadFail(e.toString()));
    }
  }
  Future<void> addContact(String uId,String peerId,String status) async {
    try{
      await repository.addContact(uId, peerId, status);
    }catch(ex){
      print(ex.toString());
    }
  }
  Future<void> searchName(String name) async {
    try{
      emit(ContactLoading());
      final users = await repository.searchUsers(name);
      emit(ContactLoaded(users));
    }catch(ex){
      emit(ContactLoadFail(ex.toString()));
    }
  }
}