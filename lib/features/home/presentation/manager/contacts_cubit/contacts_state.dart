import '../../../../auth/domain/entities/user_entity.dart';

abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsAdding extends ContactsState {
  final List<UserEntity> currentContacts;
  ContactsAdding(this.currentContacts);
}

class ContactsLoaded extends ContactsState {
  final List<UserEntity> contacts;
  ContactsLoaded(this.contacts);
}

class ContactsSuccess extends ContactsState {
  final String message;
  ContactsSuccess(this.message);
}

class ContactsFailure extends ContactsState {
  final String error;
  final List<UserEntity> previousContacts;
  ContactsFailure(this.error, {this.previousContacts = const []});
}
