import 'package:chitchat/core/services/database_services.dart';
import 'package:chitchat/features/auth/data/repo/auth_repo_impl.dart';
import 'package:chitchat/features/auth/domain/repo/auth_repo.dart';
import 'package:chitchat/features/home/domain/repo/chat_room_repo.dart';
import 'package:get_it/get_it.dart';

import '../../features/home/data/repo/chat_room_repo_impl.dart';
import 'firebase_auth_service.dart';
import 'firestore_services.dart';

final getIt = GetIt.instance;

void setupGetIt() {
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
}
