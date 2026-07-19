import 'package:injectable/injectable.dart';

import '../../core/values/app_routs_name.dart';
import '../auth/auth_manager.dart';
import '../secure_storage/secure_storage_service.dart';

@lazySingleton
class AppLaunchManager {
  final SecureStorageService _storage;
  final AuthManager _authManager;

  AppLaunchManager(this._storage, this._authManager);

  Future<String> resolveDestination() async {
    final hasSeenOnboarding = await _storage.readSeenOnboarding();

    if (!hasSeenOnboarding) {
      await _storage.writeSeenOnboarding(true);
      return AppRoutsName.onBoarding;
    }

    return _authManager.isLoggedIn
        ? AppRoutsName.sectionApp
        : AppRoutsName.loginScreen;
  }
}
