import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/get_it_services.dart';
import '../../../../core/services/shared_preferences_singleton.dart';
import '../../../groups/presentation/cubits/group_cubit/group_cubit.dart';
import '../../../groups/presentation/views/groups_screen.dart';
import '../../data/models/home_tab.dart';
import '../views/chats_home_screen.dart';
import '../views/contacts_screen.dart';
import '../views/settings_screen.dart';
import 'chat_room_cubit/chat_room_cubit.dart';

// ------------------- Tabs setup -------------------
final List<HomeTab> _tabs = [
  HomeTab(
    title: 'Chats',
    icon: Iconsax.message,
    screen: BlocProvider(
      create: (context) => getIt<ChatRoomCubit>(),
      child: const ChatHomeScreen(),
    ),
  ),
  HomeTab(
    title: 'Groups',
    icon: Iconsax.messages,
    screen: BlocProvider(
      create: (context) => getIt<GroupCubit>(),
      child: const GroupsScreen(),
    ),
  ),
  HomeTab(
    title: 'Contacts',
    icon: Iconsax.user,
    screen: const ContactsScreen(),
  ),
  HomeTab(
    title: 'Settings',
    icon: Iconsax.setting,
    screen: const SettingsScreen(),
  ),
];

// ------------------- ViewModel -------------------
class HomeViewModel extends ChangeNotifier {
  static const _keyLastTab = 'lastSelectedTab'; // key for Prefs
  int _currentIndex = 0;
  late final PageController _pageController;

  HomeViewModel() {
    // Load last tab index (if available)
    final savedIndex = Prefs.getInt(_keyLastTab) ?? 0;
    _currentIndex = savedIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  int get currentIndex => _currentIndex;
  PageController get pageController => _pageController;
  List<HomeTab> get tabs => _tabs;

  void changeTab(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      Prefs.setInt(_keyLastTab, index); // persist selected tab
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void jumpToTab(int index) {
    if (index == _currentIndex) return;
    _currentIndex = index;
    Prefs.setInt(_keyLastTab, index); // persist selected tab
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  static void goToChatTab(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    viewModel.jumpToTab(0);
  }
}
