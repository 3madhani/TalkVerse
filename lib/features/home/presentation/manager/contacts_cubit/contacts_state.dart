import 'package:equatable/equatable.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsSuccess extends ContactsState {
  final String message;

  const ContactsSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ContactsLoaded extends ContactsState {
  final List<String> contactIds;

  const ContactsLoaded(this.contactIds);

  @override
  List<Object?> get props => [contactIds];
}

class ContactsFailure extends ContactsState {
  final String error;

  const ContactsFailure(this.error);

  @override
  List<Object?> get props => [error];
}
