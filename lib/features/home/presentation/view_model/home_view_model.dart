import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../data/models/home_tab.dart';

class HomeViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<HomeTab> _tabs = [
    HomeTab(
      title: 'Chats',
      icon: Iconsax.message,
      screen: const Scaffold(body: Center(child: Text('Chats'))),
    ),
    HomeTab(
      title: 'Groups',
      icon: Iconsax.messages,
      screen: const Scaffold(body: Center(child: Text('Groups'))),
    ),
    HomeTab(
      title: 'Contacts',
      icon: Iconsax.user,
      screen: const Scaffold(body: Center(child: Text('Contacts'))),
    ),
    HomeTab(
      title: 'Settings',
      icon: Iconsax.setting,
      screen: const Scaffold(body: Center(child: Text('Settings'))),
    ),
  ];

  int get currentIndex => _currentIndex;
  PageController get pageController => _pageController;
  List<HomeTab> get tabs => _tabs;

  void changeTab(int index) {
    _currentIndex = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }
}
