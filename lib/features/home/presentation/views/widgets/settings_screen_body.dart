import 'package:chitchat/core/services/get_it_services.dart';
import 'package:chitchat/features/groups/presentation/cubits/group_cubit/group_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/cubits/chat_cubit/chat_message_cubit.dart';
import '../../../../../core/cubits/user_cubit/user_data_cubit.dart';
import '../../../../auth/presentation/manager/auth_cubit/auth_cubit.dart';
import '../../../../auth/presentation/views/login_screen.dart';
import '../../../../settings/presentation/views/profile_screen.dart';
import '../../manager/chat_room_cubit/chat_room_cubit.dart';
import '../../manager/contacts_cubit/contacts_cubit.dart';
import 'dark_tile.dart';
import 'navigation_tile.dart';
import 'profile_tile.dart';
import 'sign_out_tile.dart';
import 'theme_tile.dart';

class SettingsScreenBody extends StatelessWidget {
  const SettingsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const ProfileTile(),
          NavigationTile(
            title: 'Profile',
            icon: Iconsax.user,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider.value(
                        value:
                            getIt<UserDataCubit>()..loadUserData(
                              userId: FirebaseAuth.instance.currentUser!.uid,
                            ),
                        child: const ProfileScreen(),
                      ),
                ),
              );
            },
          ),
          const ThemeTile(),
          const DarkModeTile(),
          GestureDetector(
            onTap: () {
              // Cancel any Cubits that are listening to Firestore
              getIt<ContactsCubit>().close();
              getIt<ChatRoomCubit>().close();
              getIt<ChatMessageCubit>().close();
              getIt<UserDataCubit>().close();
              getIt<GroupCubit>().close();

              // Reset singletons to ensure fresh instances on next use
              getIt.resetLazySingleton<ChatRoomCubit>();
              getIt.resetLazySingleton<ContactsCubit>();
              getIt.resetLazySingleton<GroupCubit>();
              getIt.resetLazySingleton<ChatMessageCubit>();
              getIt.resetLazySingleton<UserDataCubit>();

              getIt<AuthCubit>().signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginScreen.routeName,
                (route) => false,
              );
            },
            child: const SignOutTile(),
          ),
        ],
      ),
    );
  }
}
