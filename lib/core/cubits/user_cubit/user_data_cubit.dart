// user_data_cubit.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/auth/data/model/user_model.dart';
import '../../../features/auth/domain/entities/user_entity.dart';
import '../../repos/images_repo/images_repo.dart';
import '../../repos/user_data_repo/user_data_repo.dart';
import '../../services/shared_preferences_singleton.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  static const userDataCacheKeySingle = "user_data_cache_single";
  static const userDataCacheKeyMulti = "user_data_cache_multi";
final ImagesRepo imagesRepo;
  final UserDataRepo userDataRepo;
  StreamSubscription? _userDataSubscription;

  UserDataCubit({ required this.userDataRepo, required this.imagesRepo}) : super(UserDataInitial());

  @override
  Future<void> close() {
    _userDataSubscription?.cancel();
    return super.close();
  }

  Future<void> loadUserData({String? userId, List<String>? usersIds}) async {
    if (userId == null && usersIds == null) {
      emit(const UserDataError("No userId or usersIds provided"));
      return;
    }

    // --------------------
    // Load from Cache أولاً
    // --------------------
    if (usersIds != null) {
      final cachedData = Prefs.getString(userDataCacheKeyMulti);
      if (cachedData.isNotEmpty) {
        try {
          final usersList =
              (jsonDecode(cachedData) as List)
                  .map((e) => UserModel.fromJson(e))
                  .toList();
          emit(UsersDataLoaded(usersList, isFromCache: true));
        } catch (_) {
          emit(const UserDataError("Failed to parse cached users data"));
        }
      }
    } else if (userId != null) {
      final cachedData = Prefs.getString(userDataCacheKeySingle);
      if (cachedData.isNotEmpty) {
        try {
          final user = UserModel.fromJson(jsonDecode(cachedData));
          emit(UserDataLoaded(user, isFromCache: true));
        } catch (_) {
          emit(const UserDataError("Failed to parse cached user data"));
        }
      }
    }

    // --------------------
    // Cancel old subscription
    // --------------------
    _userDataSubscription?.cancel();

    // --------------------
    // Load fresh data
    // --------------------
    if (usersIds != null) {
      _userDataSubscription = userDataRepo.getUsersData(usersIds).listen((
        result,
      ) {
        result.fold((failure) => emit(UserDataError(failure.message)), (
          usersData,
        ) {
          if (usersData.isNotEmpty) {
            Prefs.setString(
              userDataCacheKeyMulti,
              jsonEncode(
                usersData.map((u) => (u as UserModel).toJson()).toList(),
              ),
            );
            emit(UsersDataLoaded(usersData));
          } else {
            emit(const UserDataError("No users data found"));
          }
        });
      });
    } else if (userId != null) {
      _userDataSubscription = userDataRepo.getUserData(userId).listen((result) {
        result.fold((failure) => emit(UserDataError(failure.message)), (
          userData,
        ) {
          Prefs.setString(
            userDataCacheKeySingle,
            jsonEncode((userData as UserModel).toJson()),
          );
          emit(UserDataLoaded(userData));
        });
      });
    }
  }

  Future<void> updateUserData({required Map<String, dynamic> data}) async {
    emit(UserDataLoading());
    final result = await userDataRepo.updateUserData(data: data);
    result.fold((failure) {
      emit(UserDataUpdateError(failure.message));
    }, (_) {
      emit(const UserDataUpdated("User data updated successfully"));
    });
  }

  Future<String?> uploadProfileImage(File? image,) async {
    try {
      final imageUrl = await imagesRepo.uploadImage(
        image: image!,
        path: "Users-Profile-Images/${FirebaseAuth.instance.currentUser!.uid}",
      );
      return imageUrl.fold((failure) {
        emit(UserDataUpdateError(failure.message));
        return null;
      }, (url) => url);
    } catch (e) {
      emit(UserDataUpdateError("Image upload failed: $e"));
      return null;
    }
  }
}
