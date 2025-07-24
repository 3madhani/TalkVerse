import 'package:get_it/get_it.dart';

import '../../features/auth/data/repo/auth_repo_impl.dart';
import '../../features/auth/domain/repo/auth_repo.dart';
import '../../features/chats/data/repos/chat_message_repo_impl.dart';
import '../../features/chats/domain/repo/chat_message_repo.dart';
import '../../features/home/data/repos/chat_room_repo_impl.dart';
import '../../features/home/data/repos/contacts_repo_impl.dart';
import '../../features/home/domain/repos/chat_room_repo.dart';
import '../../features/home/domain/repos/contacts_repo.dart';
import '../images_repo/images_repo.dart';
import '../images_repo/images_repo_impl.dart';
import 'database_services.dart';
import 'firebase_auth_service.dart';
import 'firestore_services.dart';
import 'storage_services.dart';
import 'supabase_storage.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<StorageServices>(SupabaseStorage());
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseServices>(FireStoreServices());

  getIt.registerSingleton<ImagesRepo>(
    ImagesRepoImpl(storageServices: getIt.get<StorageServices>()),
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
}
