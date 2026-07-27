import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../core/values/api_parameters.dart';
import 'auth_manager.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final AuthManager _authManager;

  AuthInterceptor(this._authManager);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requiresAuth = options.extra[ApiParameters.requiresAuth] ?? true;

    if (requiresAuth) {
      final token = _authManager.token;

      if (token != null && token.isNotEmpty) {
        options.headers['token'] = token;
        options.headers[ApiParameters.authorization] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401) {
      await _authManager.logout();
    }

    handler.next(err);
  }
}
