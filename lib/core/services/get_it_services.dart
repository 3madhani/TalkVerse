import 'package:chitchat/core/services/supabase_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/repo/auth_repo_impl.dart';
import '../../features/auth/domain/repo/auth_repo.dart';
import '../../features/chats/data/repos/chat_message_repo_impl.dart';
import '../../features/chats/domain/repo/chat_message_repo.dart';
import '../../features/home/data/repo/chat_room_repo_impl.dart';
import '../../features/home/domain/repo/chat_room_repo.dart';
import 'database_services.dart';
import 'firebase_auth_service.dart';
import 'firestore_services.dart';
import 'storage_services.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<StorageServices>(SupabaseStorage());
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseServices>(FireStoreServices());

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
