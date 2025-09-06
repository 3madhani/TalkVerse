import 'dart:async';
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
  StreamSubscription? _contactsSubscription;

  ContactsCubit({required this.contactsRepo}) : super(ContactsInitial());

  Future<void> addContact(String email) async {
    emit(ContactsAdding(_contacts));

    final result = await contactsRepo.createContact(email);

    result.fold(
      (failure) {
        emit(ContactsFailure(failure.message, previousContacts: _contacts));
        emit(ContactsLoaded(_contacts));
      },
      (message) async {
        await loadContacts(); // Reload contacts
        emit(ContactsSuccess(message));
      },
    );
  }

  void clearSearch() {
    emit(ContactsLoaded(_contacts));
  }

  @override
  Future<void> close() {
    _contactsSubscription?.cancel();
    return super.close();
  }

  Future<void> deleteContact(String uId) async {
    final previousContacts = List<UserEntity>.from(_contacts);

    _contacts = List<UserEntity>.from(_contacts)
      ..removeWhere((c) => c.uId == uId);

    emit(ContactsLoaded(_contacts));

    final result = await contactsRepo.deleteContact(uId);
    result.fold(
      (failure) {
        _contacts = previousContacts;
        emit(
          ContactsFailure(previousContacts: previousContacts, failure.message),
        );
      },
      (_) async {
        await _saveContactsToPrefs(_contacts);
      },
    );
  }

  Future<void> loadContacts() async {
    final cached = await _loadContactsFromPrefs();
    if (cached.isNotEmpty) {
      _contacts = List<UserEntity>.from(cached)..sort(_sortByName);
      emit(ContactsLoaded(_contacts));

      await Future.delayed(const Duration(milliseconds: 100));
    } else {
      emit(ContactsLoading());
    }

    await _contactsSubscription?.cancel();

    try {
      final contactsStream = contactsRepo.getContacts();

      _contactsSubscription = contactsStream.listen((either) async {
        if (isClosed) return; // stop if cubit is closed

        either.fold(
          (failure) {
            if (!isClosed) {
              emit(
                ContactsFailure(failure.message, previousContacts: _contacts),
              );
            }
          },
          (contacts) async {
            _contacts = List<UserEntity>.from(contacts)..sort(_sortByName);
            await _saveContactsToPrefs(_contacts);
            if (!isClosed) {
              emit(ContactsLoaded(_contacts));
            }
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

  Future<void> searchContacts(String query) async {
    try {
      final filtered =
          _contacts
              .where(
                (element) =>
                    element.name?.toLowerCase().contains(query.toLowerCase()) ??
                    false,
              )
              .toList()
            ..sort(_sortByName);

      emit(ContactsLoaded(filtered));
    } catch (e) {
      emit(ContactsFailure("Search failed: $e", previousContacts: _contacts));
    }
  }

  void sortContacts() {
    _contacts.sort(_sortByName);
    emit(ContactsLoaded(_contacts));
  }

  Future<List<UserEntity>> _loadContactsFromPrefs() async {
    final jsonString = Prefs.getString(_cacheKey);
    try {
      final decoded = jsonDecode(jsonString) as List;
      return decoded.map((e) {
        return UserEntity(
          uId: e['uId'],
          email: e['email'],
          name: e['name'],
          photoUrl: e['photoUrl'],
          aboutMe: e['aboutMe'],
        );
      }).toList();
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

  int _sortByName(UserEntity a, UserEntity b) {
    final nameA = a.name?.toLowerCase() ?? '';
    final nameB = b.name?.toLowerCase() ?? '';
    return nameA.compareTo(nameB);
  }
}
