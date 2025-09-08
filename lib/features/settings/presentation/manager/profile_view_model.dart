import 'package:chitchat/core/services/get_it_services.dart';
import 'package:chitchat/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/cubits/user_cubit/user_data_cubit.dart';

class ProfileViewModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  String profilePictureUrl = "";

  bool enableName = false;
  bool enableAbout = false;

  @override
  void dispose() {
    nameController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  Future<void> saveProfile({
    String? name,
    String? about,
    String? profilePicture,
  }) async {
    final data = <String, dynamic>{};
    if (enableName && name != null && name.isNotEmpty) {
      data['name'] = name;
    }
    if (enableAbout && about != null && about.isNotEmpty) {
      data['aboutMe'] = about;
    }
    if (profilePicture != null && profilePicture.isNotEmpty) {
      data['photoUrl'] = profilePicture;
    }
    if (data.isNotEmpty) {
      await getIt<UserDataCubit>().updateUserData(data: data);
    }
    if (enableAbout || enableName)
    // Reset edit states
    {
      enableAbout = false;
      enableName = false;
    } else
    // If nothing was changed, just reset states
    {
      enableName = false;
      enableAbout = false;
    }
    getIt<UserDataCubit>().loadSingleUserData(
      userId: FirebaseAuth.instance.currentUser!.uid,
    );
    notifyListeners();
  }

  void setUser(UserEntity user) {
    nameController.text = user.name ?? '';
    aboutController.text = user.aboutMe ?? 'Write about yourself...';
    profilePictureUrl = user.photoUrl ?? 'Write about yourself...';
    notifyListeners();
  }

  void toggleEditAbout() {
    enableAbout = !enableAbout;
    notifyListeners();
  }

  void toggleEditName() {
    enableName = !enableName;
    notifyListeners();
  }
}
