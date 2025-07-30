import 'package:get_it/get_it.dart';

import '../../features/auth/data/repo/auth_repo_impl.dart';
import '../../features/auth/domain/repo/auth_repo.dart';
import '../../features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import '../../features/chats/data/repos/chat_message_repo_impl.dart';
import '../../features/chats/domain/repo/chat_message_repo.dart';
import '../../features/chats/presentation/manager/chat_cubit/chat_message_cubit.dart';
import '../../features/groups/data/repos/group_repo_impl.dart';
import '../../features/groups/domain/repos/group_repo.dart';
import '../../features/groups/presentation/cubits/group_cubit/group_cubit.dart';
import '../../features/home/data/repos/chat_room_repo_impl.dart';
import '../../features/home/data/repos/contacts_repo_impl.dart';
import '../../features/home/domain/repos/chat_room_repo.dart';
import '../../features/home/domain/repos/contacts_repo.dart';
import '../../features/home/presentation/manager/chat_room_cubit/chat_room_cubit.dart';
import '../../features/home/presentation/manager/contacts_cubit/contacts_cubit.dart';
import '../images_repo/images_repo.dart';
import '../images_repo/images_repo_impl.dart';
import 'database_services.dart';
import 'firebase_auth_service.dart';
import 'firestore_services.dart';
import 'storage_services.dart';
import 'supabase_storage.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  /// Core services
  getIt.registerSingleton<StorageServices>(SupabaseStorage());
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseServices>(FireStoreServices());

  /// Repos
  getIt.registerSingleton<ImagesRepo>(
    ImagesRepoImpl(storageServices: getIt<StorageServices>()),
  );

  getIt.registerSingleton<ContactsRepo>(
    ContactsRepoImpl(databaseServices: getIt<DatabaseServices>()),
  );

  getIt.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      firebaseAuthService: getIt<FirebaseAuthService>(),
      databaseServices: getIt<DatabaseServices>(),
    ),
  );

  getIt.registerSingleton<ChatRoomRepo>(
    ChatRoomRepoImpl(databaseServices: getIt<DatabaseServices>()),
  );

  getIt.registerSingleton<ChatMessageRepo>(
    ChatMessageRepoImpl(databaseServices: getIt<DatabaseServices>()),
  );

  getIt.registerSingleton<GroupRepo>(
    GroupRepoImpl(databaseServices: getIt<DatabaseServices>()),
  );

  /// Cubits - Lazy Singletons
  getIt.registerLazySingleton<AuthCubit>(() => AuthCubit(getIt<AuthRepo>()));

  getIt.registerLazySingleton<ChatRoomCubit>(
    () => ChatRoomCubit(getIt<ChatRoomRepo>()),
  );

  getIt.registerLazySingleton<ChatMessageCubit>(
    () => ChatMessageCubit(getIt<ChatMessageRepo>(), getIt<ImagesRepo>()),
  );

  getIt.registerLazySingleton<ContactsCubit>(
    () => ContactsCubit(contactsRepo: getIt<ContactsRepo>()),
  );

  getIt.registerLazySingleton<GroupCubit>(() => GroupCubit(getIt<GroupRepo>()));
}
