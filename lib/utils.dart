import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:nyaa/firebase_options.dart';
import 'package:nyaa/services/alert_service.dart';
import 'package:nyaa/services/auth_service.dart';
import 'package:nyaa/services/database_service.dart';
import 'package:nyaa/services/media_service.dart';
import 'package:nyaa/services/navigation_service.dart';
import 'package:nyaa/services/storage_service.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;

  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<AlertService>(AlertService());
  getIt.registerSingleton<MediaService>(MediaService());
  getIt.registerSingleton<StorageService>(StorageService());
  getIt.registerSingleton<DatabaseService>(DatabaseService());
}

String generateChatID({required String uid1, required String uid2}) {
  List uids = [uid1, uid2];
  uids.sort();
  String chatID = uids.fold("", (id, uid) {
    return "$id$uid";
  });

  return chatID;
}
