import 'package:flutter/material.dart';

class ContactsViewModel extends ChangeNotifier {
  bool _searched = false;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool get searched => _searched;
  TextEditingController get searchController => _searchController;
  TextEditingController get emailController => _emailController;

  void toggleSearch() {
    _searched = !_searched;
    if (!_searched) {
      _searchController.clear();
    }
    notifyListeners();
  }

  void clearSearch() {
    _searched = false;
    _searchController.clear();
    notifyListeners();
  }
}
