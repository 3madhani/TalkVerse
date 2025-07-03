import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  bool _enableName = false;
  bool _enableAbout = false;

  ProfileViewModel() {
    // Initialize with default values
    nameController.text = 'John Doe';
    aboutController.text =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
  }
  bool get enableAbout => _enableAbout;

  bool get enableName => _enableName;

  @override
  void dispose() {
    nameController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  void saveProfile() {
    // Handle profile save logic here (e.g., API call)
    debugPrint(
      'Profile Saved: Name - ${nameController.text}, About - ${aboutController.text}',
    );
  }

  void toggleEditAbout() {
    _enableAbout = !_enableAbout;
    notifyListeners();
  }

  void toggleEditName() {
    _enableName = !_enableName;
    notifyListeners();
  }
}
