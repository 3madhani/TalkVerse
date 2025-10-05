import 'package:flutter/material.dart';

import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/views/forget_password_screen.dart';
import '../../features/auth/presentation/views/login_screen.dart';
import '../../features/auth/presentation/views/setup_profile.dart';
import '../../features/auth/presentation/views/verify_email_screen.dart';
import '../../features/chats/presentation/views/chat_screen.dart';
import '../../features/groups/domain/entities/group_entity.dart';
import '../../features/groups/presentation/views/create_group_screen.dart';
import '../../features/groups/presentation/views/group_chat_screen.dart';
import '../../features/groups/presentation/views/group_edit_screen.dart';
import '../../features/groups/presentation/views/group_member_screen.dart';
import '../../features/groups/presentation/views/groups_screen.dart';
import '../../features/home/domain/entities/chat_room_entity.dart';
import '../../features/home/presentation/views/chats_home_screen.dart';
import '../../features/home/presentation/views/contacts_screen.dart';
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
    case ChatScreen.routeName:
      return MaterialPageRoute(
        builder:
            (context) => ChatScreen(
              chatRoom:
                  (settings.arguments as Map)['chatRoom'] as ChatRoomEntity,
              user: (settings.arguments as Map)['user'] as UserEntity?,
              currentUser: (settings.arguments as Map)['currentUser'] as UserEntity,
            ),
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
      final args = settings.arguments as GroupMemberArgs;
      return MaterialPageRoute(
        builder:
            (context) =>
                GroupMemberScreen(group: args.group,),
      );
    case GroupChatScreen.routeName:
      return MaterialPageRoute(
        builder:
            (context) =>
                GroupChatScreen(group: settings.arguments as GroupEntity),
      );
    case GroupEditScreen.routeName:
      return MaterialPageRoute(
        builder:
            (context) =>
                GroupEditScreen(group: settings.arguments as GroupEntity),
      );
    case VerifyEmailScreen.routeName:
      return MaterialPageRoute(builder: (context) => const VerifyEmailScreen());
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

class GroupMemberArgs {
  final GroupEntity group;

  GroupMemberArgs({required this.group,});
}
