import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/get_it_services.dart';
import '../../../groups/presentation/cubits/group_cubit/group_cubit.dart';
import '../../../groups/presentation/views/groups_screen.dart';
import '../../data/models/home_tab.dart';
import '../views/chats_home_screen.dart';
import '../views/contacts_screen.dart';
import '../views/settings_screen.dart';
import 'chat_room_cubit/chat_room_cubit.dart';

class HomeViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

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

  int get currentIndex => _currentIndex;
  PageController get pageController => _pageController;
  List<HomeTab> get tabs => _tabs;

  void changeTab(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void jumpToTab(int index) {
    _currentIndex = index;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  static void goToChatTab(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    viewModel.jumpToTab(0); // assuming tab index 0 is the chat tab
  }
}
