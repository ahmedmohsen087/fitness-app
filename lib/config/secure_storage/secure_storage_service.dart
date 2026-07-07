import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../core/values/app_strings.dart';
import '../../core/values/secure_storage_keys.dart';
import 'local_storage_exception.dart';

@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  SecureStorageService(this._secureStorage);

  Future<void> writeToken(String token) async {
    try {
      if (token.isEmpty) {
        throw LocalStorageException(AppStrings.tokenEmpty);
      }

      await _secureStorage.write(key: SecureStorageKeys.token, value: token);
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.tokenWriteFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<String?> readToken() async {
    try {
      return await _secureStorage.read(key: SecureStorageKeys.token);
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.tokenReadFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: SecureStorageKeys.token);
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.tokenDeleteFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> writeRememberMe(bool value) async {
    try {
      await _secureStorage.write(
        key: SecureStorageKeys.rememberMe,
        value: value.toString(),
      );
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.rememberMeWriteFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<bool> readRememberMe() async {
    try {
      final value = await _secureStorage.read(
        key: SecureStorageKeys.rememberMe,
      );

      return value == 'true';
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.rememberMeReadFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> deleteRememberMe() async {
    try {
      await _secureStorage.delete(key: SecureStorageKeys.rememberMe);
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.rememberMeDeleteFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> writeSeenOnboarding(bool value) async {
    try {
      await _secureStorage.write(
        key: SecureStorageKeys.seenOnboarding,
        value: value.toString(),
      );
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.seenOnboardingWriteFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<bool> readSeenOnboarding() async {
    try {
      final value = await _secureStorage.read(
        key: SecureStorageKeys.seenOnboarding,
      );

      return value == 'true';
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.seenOnboardingReadFailed,
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> clearAuthData() async {
    try {
      await _secureStorage.delete(key: SecureStorageKeys.token);
      await _secureStorage.delete(key: SecureStorageKeys.userId);
      await _secureStorage.delete(key: SecureStorageKeys.rememberMe);
    } catch (e, s) {
      throw LocalStorageException(
        AppStrings.clearStorageFailed,
        error: e,
        stackTrace: s,
      );
    }
  }
}
