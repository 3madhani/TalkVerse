import 'package:flutter/material.dart';

import '../../features/auth/presentation/views/forget_password_screen.dart';
import '../../features/auth/presentation/views/login_screen.dart';
import '../../features/auth/presentation/views/setup_profile.dart';
import '../../features/groups/presentation/views/create_group_screen.dart';
import '../../features/groups/presentation/views/group_edit_screen.dart';
import '../../features/groups/presentation/views/group_member_screen.dart';
import '../../features/groups/presentation/views/group_screen.dart';
import '../../features/home/presentation/views/chat_home_screen.dart';
import '../../features/home/presentation/views/contacts_screen.dart';
import '../../features/home/presentation/views/groups_screen.dart';
import '../../features/home/presentation/views/home_layout.dart';
import '../../features/home/presentation/views/settings_screen.dart';
import '../../features/settings/presentation/views/profile_screen.dart';
import '../../features/settings/presentation/views/qr_code_screen.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case HomeLayout.routeName:
      return MaterialPageRoute(builder: (context) => const HomeLayout());
    case ChatHomeScreen.routeName:
      return MaterialPageRoute(builder: (context) => const ChatHomeScreen());
    case ProfileScreen.routeName:
      return MaterialPageRoute(builder: (context) => const ProfileScreen());
    case QrCodeScreen.routeName:
      return MaterialPageRoute(builder: (context) => const QrCodeScreen());
    case ForgetPasswordScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const ForgetPasswordScreen(),
      );
    case SettingsScreen.routeName:
      return MaterialPageRoute(builder: (context) => const SettingsScreen());
    case ContactsScreen.routeName:
      return MaterialPageRoute(builder: (context) => const ContactsScreen());
    case SetupProfile.routeName:
      return MaterialPageRoute(builder: (context) => const SetupProfile());
    case GroupsScreen.routeName:
      return MaterialPageRoute(builder: (context) => const GroupsScreen());
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(builder: (context) => const CreateGroupScreen());
    case GroupMemberScreen.routeName:
      return MaterialPageRoute(builder: (context) => const GroupMemberScreen());
    case GroupScreen.routeName:
      return MaterialPageRoute(builder: (context) => const GroupScreen());
    case GroupEditScreen.routeName:
      return MaterialPageRoute(builder: (context) => const GroupEditScreen());
    default:
      return MaterialPageRoute(
        builder:
            (context) => Scaffold(
              body: Center(
                child: Text(
                  'Error 404',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
      );
  }
}
