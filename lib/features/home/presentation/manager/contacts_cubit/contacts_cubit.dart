import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/shared_preferences_singleton.dart';
import '../../../../auth/domain/entities/user_entity.dart';
import '../../../domain/repos/contacts_repo.dart';
import 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  static const String _cacheKey = 'cached_contacts';

  final ContactsRepo contactsRepo;

  List<UserEntity> _contacts = [];

  ContactsCubit({required this.contactsRepo}) : super(ContactsInitial());

  Future<void> addContact(String email) async {
    // Instead of clearing everything with ContactsLoading, show a non-blocking loading state
    emit(ContactsAdding(_contacts));

    final result = await contactsRepo.createContact(email);

    result.fold(
      (failure) {
        emit(ContactsFailure(failure.message, previousContacts: _contacts));
        emit(ContactsLoaded(_contacts)); // restore contacts
      },
      (message) async {
        await loadContacts(); // Reload contacts from Firestore
        emit(ContactsSuccess(message));
      },
    );
  }

  Future<void> loadContacts() async {
    // Load cached contacts first
    final cached = await _loadContactsFromPrefs();
    if (cached.isNotEmpty) {
      _contacts = cached;
      emit(ContactsLoaded(_contacts));
    } else {
      emit(ContactsLoading());
    }

    try {
      final contactsStream = contactsRepo.getContacts();

      contactsStream.listen((either) async {
        either.fold(
          (failure) {
            emit(ContactsFailure(failure.message, previousContacts: _contacts));
          },
          (contacts) async {
            _contacts = contacts;
            await _saveContactsToPrefs(contacts);
            emit(ContactsLoaded(_contacts));
          },
        );
      });
    } catch (e) {
      emit(
        ContactsFailure(
          "Failed to load contacts: $e",
          previousContacts: _contacts,
        ),
      );
    }
  }

  Future<List<UserEntity>> _loadContactsFromPrefs() async {
    final jsonString = Prefs.getString(_cacheKey);
    try {
      final decoded = jsonDecode(jsonString) as List;
      return decoded
          .map(
            (e) => UserEntity(
              uId: e['uId'],
              email: e['email'],
              name: e['name'],
              photoUrl: e['photoUrl'],
              aboutMe: e['aboutMe'],
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveContactsToPrefs(List<UserEntity> contacts) async {
    final encoded = jsonEncode(
      contacts
          .map(
            (e) => {
              "uId": e.uId,
              "email": e.email,
              "name": e.name,
              "photoUrl": e.photoUrl,
              "aboutMe": e.aboutMe,
            },
          )
          .toList(),
    );
    await Prefs.setString(_cacheKey, encoded);
  }
}
