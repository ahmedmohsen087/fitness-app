import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import '../../core/values/api_endpoints.dart';

class SmartCacheInterceptor extends Interceptor {
  static final _mealDbHost = Uri.parse(ApiEndpoints.mealDbBaseUrl).host;
  static final _foodPaths = {
    Uri.parse(ApiEndpoints.recommendationFood).path,
    Uri.parse(ApiEndpoints.mealsByCategory).path,
  };

  final CacheOptions foodOptions;

  SmartCacheInterceptor({required this.foodOptions});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final uri = options.uri;
    if (uri.host == _mealDbHost && _foodPaths.contains(uri.path)) {
      options.extra.addAll(foodOptions.toExtra());
    }
    handler.next(options);
  }
}
