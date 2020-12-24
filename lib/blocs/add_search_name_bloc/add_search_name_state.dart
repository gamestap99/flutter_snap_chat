
import 'package:equatable/equatable.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

abstract class AddSearchNameState extends Equatable{

}
class AddSearchNameLoading extends AddSearchNameState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class AddSearchNameLoaded extends AddSearchNameState{
  final List<UserModel> users;

  AddSearchNameLoaded(this.users);
  @override
  // TODO: implement props
  List<Object> get props => [users];

}
class AddSearchNameLoadFailure extends AddSearchNameState{
  final String eror;

  AddSearchNameLoadFailure(this.eror);
  @override
  // TODO: implement props
  List<Object> get props => [eror];
}