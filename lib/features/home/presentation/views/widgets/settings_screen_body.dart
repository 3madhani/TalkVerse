import 'package:chitchat/core/services/get_it_services.dart';
import 'package:chitchat/features/groups/presentation/cubits/group_cubit/group_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/cubits/chat_cubit/chat_message_cubit.dart';
import '../../../../../core/cubits/user_cubit/user_data_cubit.dart';
import '../../../../../core/repos/images_repo/images_repo.dart';
import '../../../../../core/repos/user_data_repo/user_data_repo.dart';
import '../../../../../core/services/shared_preferences_singleton.dart';
import '../../../../auth/presentation/manager/auth_cubit/auth_cubit.dart';
import '../../../../groups/presentation/cubits/group_selection_cubit/group_selection_cubit.dart';
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
                            getIt<UserDataCubit>()..loadSingleUserData(
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
            onTap: () async {
              await getIt<UserDataCubit>().updateUserLastSeen(online: false);
              // --- Close all Cubits ---
              getIt<ContactsCubit>().close();
              getIt<ChatRoomCubit>().close();
              getIt<ChatMessageCubit>().close();
              getIt<GroupCubit>().close();
              getIt<UserDataCubit>().close();

              // --- Reset lazy singletons (to create new instances next time) ---
              getIt.resetLazySingleton<ContactsCubit>();
              getIt.resetLazySingleton<ChatRoomCubit>();
              getIt.resetLazySingleton<ChatMessageCubit>();
              getIt.resetLazySingleton<GroupCubit>();
              getIt.resetLazySingleton<AuthCubit>();
              getIt.resetLazySingleton<GroupSelectionCubit>();

              // --- Reset user data cubit factory (to ensure a clean re-registration) ---
              getIt.unregister<UserDataCubit>();
              getIt.registerFactory<UserDataCubit>(
                () => UserDataCubit(
                  userDataRepo: getIt<UserDataRepo>(),
                  imagesRepo: getIt<ImagesRepo>(),
                ),
              );
              // --- Reset Shared Preferences ---
              await Prefs.reset();

              await getIt<AuthCubit>().signOut();
            },
            child: const SignOutTile(),
          ),
        ],
      ),
    );
  }
}
