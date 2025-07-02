import 'package:chitchat/features/home/presentation/views/chat_home_screen.dart';
import 'package:chitchat/features/home/presentation/views/contacts_screen.dart';
import 'package:chitchat/features/home/presentation/views/groups_screen.dart';
import 'package:chitchat/features/home/presentation/views/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/services/get_it_services.dart';
import '../../data/models/home_tab.dart';
import '../../domain/repo/chat_room_repo.dart';
import 'chat_room_cubit/chat_room_cubit.dart';

class HomeViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<HomeTab> _tabs = [
    HomeTab(
      title: 'Chats',
      icon: Iconsax.message,
      screen: BlocProvider(
        create: (context) {
          final cubit = ChatRoomCubit(getIt<ChatRoomRepo>());

          final uid = FirebaseAuth.instance.currentUser!.uid;

          // 👇 Async init
          Future.microtask(() async {
            await cubit.loadCachedChatRooms();
            cubit.listenToUserChatRooms(uid);
          });

          return cubit;
        },
        child: const ChatHomeScreen(),
      ),
    ),

    HomeTab(
      title: 'Groups',
      icon: Iconsax.messages,
      screen: const GroupsScreen(),
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
    _currentIndex = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }
}
