import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  bool _enableName = false;
  bool _enableAbout = false;

  bool get enableName => _enableName;
  bool get enableAbout => _enableAbout;

  ProfileViewModel() {
    // Initialize with default values
    nameController.text = 'John Doe';
    aboutController.text =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
  }

  void toggleEditName() {
    _enableName = !_enableName;
    notifyListeners();
  }

  void toggleEditAbout() {
    _enableAbout = !_enableAbout;
    notifyListeners();
  }

  void saveProfile() {
    // Handle profile save logic here (e.g., API call)
    debugPrint(
      'Profile Saved: Name - ${nameController.text}, About - ${aboutController.text}',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    aboutController.dispose();
    super.dispose();
  }
}
