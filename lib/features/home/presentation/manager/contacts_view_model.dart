import 'package:flutter/material.dart';

class ContactsViewModel extends ChangeNotifier {
  bool _searched = false;
  final TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;
  bool get searched => _searched;

  void clearSearch() {
    _searched = false;
    _searchController.clear();
    notifyListeners();
  }

  void toggleSearch() {
    _searched = !_searched;
    if (!_searched) {
      _searchController.clear();
    }
    notifyListeners();
  }
}
