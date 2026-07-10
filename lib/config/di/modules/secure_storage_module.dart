import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class SecureStorageModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    aOptions: AndroidOptions(
      storageNamespace: 'secure_prefs',
      preferencesKeyPrefix: 'app_',
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
      synchronizable: false,
      accountName: 'app_secure_storage',
    ),
  );
}
