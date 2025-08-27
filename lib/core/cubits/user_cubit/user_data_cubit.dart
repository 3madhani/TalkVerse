import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/auth/domain/entities/user_entity.dart';
import '../../repos/user_data_repo/user_data_repo.dart';
import '../../services/shared_preferences_singleton.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  static const userDataCacheKey = "user_data_cache";
  final UserDataRepo userDataRepo;
  StreamSubscription? _userDataSubscription;
  UserDataCubit(this.userDataRepo) : super(UserDataInitial());

  @override
  Future<void> close() {
    _userDataSubscription?.cancel();
    return super.close();
  }

  Future<void> loadUserData({String? userId, List<String>? usersIds}) async {
    emit(UserDataLoading());
    final cachedData = Prefs.getString(userDataCacheKey);
    if (cachedData.isNotEmpty) {
      try {
        final user = jsonDecode(cachedData);
        emit(UserDataLoaded(user));
      } catch (_) {
        emit(const UserDataError("Failed to parse cached user data"));
      }
    }
    _userDataSubscription?.cancel();
    if (usersIds != null) {
      _userDataSubscription = userDataRepo.getUsersData(usersIds).listen((
        result,
      ) {
        result.fold((failure) => emit(UserDataError(failure.message)), (
          usersData,
        ) {
          if (usersData.isNotEmpty) {
            final usersList = usersData;
            Prefs.setString(userDataCacheKey, jsonEncode(usersList));
            emit(UsersDataLoaded(usersList));
          } else {
            emit(const UserDataError("No users data found"));
          }
        });
      });
      return;
    } else if (userId != null) {
      _userDataSubscription = userDataRepo.getUserData(userId).listen((result) {
        result.fold((failure) => emit(UserDataError(failure.message)), (
          userData,
        ) {
          final user = userData;
          Prefs.setString(userDataCacheKey, jsonEncode(user));
          emit(UserDataLoaded(user));
        });
      });
    }
  }
}
