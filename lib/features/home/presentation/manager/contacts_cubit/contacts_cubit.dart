
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repos/contacts_repo.dart';
import 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final ContactsRepo contactsRepo;

  ContactsCubit({required this.contactsRepo}) : super(ContactsInitial());

  Future<void> addContact(String email) async {
    emit(ContactsLoading());

    final result = await contactsRepo.createContact(email);

    result.fold(
      (failure) => emit(ContactsFailure(failure.message)),
      (message) => emit(ContactsSuccess(message)),
    );
  }

  Future<void> loadContacts() async {
    emit(ContactsLoading());

    try {
      final contactsStream = contactsRepo.getContacts();

      contactsStream.listen((either) {
        either.fold(
          (failure) => emit(ContactsFailure(failure.message)),
          (contacts) => emit(ContactsLoaded(contacts)),
        );
      });
    } catch (e) {
      emit(ContactsFailure("Failed to load contacts: $e"));
    }
  }
}
