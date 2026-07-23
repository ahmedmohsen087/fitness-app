import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:injectable/injectable.dart';

import '../../core/values/app_strings.dart';
import '../secure_storage/secure_storage_service.dart';

@lazySingleton
class AuthManager {
  final SecureStorageService _storage;
  final CacheStore _cacheStore;

  String? _token;

  AuthManager(this._storage, this._cacheStore);

  String? get token => _token;

  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  Future<void> init() async {
    final rememberMe = await _storage.readRememberMe();

    if (!rememberMe) {
      _token = null;
      return;
    }

    final savedToken = await _storage.readToken();
    if (savedToken != null && savedToken.isNotEmpty) {
      _token = savedToken;
    }
  }

  Future<void> setRememberMe(bool rememberMe) async {
    await _storage.writeRememberMe(rememberMe);
  }

  Future<void> setAuthData({required String token, bool? rememberMe}) async {
    if (token.isEmpty) {
      throw Exception(AppStrings.tokenEmpty);
    }

    _token = token;

    if (rememberMe != null) {
      await _storage.writeRememberMe(rememberMe);
    }

    final shouldRemember = rememberMe ?? await _storage.readRememberMe();
    if (shouldRemember) {
      await _storage.writeToken(token);
    } else {
      await _storage.deleteToken();
    }
  }

  Future<void> logout() async {
    _token = null;

    await _storage.clearAuthData();
    await _cacheStore.clean();
  }
}
