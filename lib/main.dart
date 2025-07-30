import 'package:chitchat/my_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/images_repo/images_repo.dart';
import 'core/services/get_it_services.dart';
import 'core/services/shared_preferences_singleton.dart';
import 'core/services/supabase_storage.dart';
import 'features/auth/domain/repo/auth_repo.dart';
import 'features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'features/chats/domain/repo/chat_message_repo.dart';
import 'features/chats/presentation/manager/chat_cubit/chat_message_cubit.dart';
import 'features/groups/domain/repos/group_repo.dart';
import 'features/groups/presentation/cubits/group_cubit/group_cubit.dart';
import 'features/home/domain/repos/chat_room_repo.dart';
import 'features/home/domain/repos/contacts_repo.dart';
import 'features/home/presentation/manager/chat_room_cubit/chat_room_cubit.dart';
import 'features/home/presentation/manager/contacts_cubit/contacts_cubit.dart';
import 'features/home/presentation/manager/theme_view_model.dart';
import 'firebase_options.dart';

void main() async {
  // ensure widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Supabase
  await SupabaseStorage.initSupabase();

  // Create Supabase bucket
  // await SupabaseStorage.createBucket("chat-images");
  // Initialize shared preferences
  await Prefs.init();

  // intia;ize getIt
  setupGetIt();

  // run app
  runApp(
    // wrap app with provider
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(getIt<AuthRepo>())),
        BlocProvider(
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
        ),
        BlocProvider(
          create:
              (context) => ChatMessageCubit(
                getIt<ChatMessageRepo>(),
                getIt<ImagesRepo>(),
              ),
        ),
        BlocProvider(
          create:
              (context) =>
                  ContactsCubit(contactsRepo: getIt<ContactsRepo>())
                    ..loadContacts(),
        ),
        BlocProvider(
          create: (context) => GroupCubit(getIt<GroupRepo>())..listenToGroups(),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (context) => ThemeViewModel(),
        child: const TalkVerse(),
      ),
    ),
  );
}
