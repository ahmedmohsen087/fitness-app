import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:fitness_app/config/cache/smart_cache_interceptor.dart';
import 'package:fitness_app/core/values/api_endpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CacheOptions foodOptions;
  late SmartCacheInterceptor interceptor;

  setUp(() {
    foodOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.forceCache,
      maxStale: const Duration(days: 1),
    );
    interceptor = SmartCacheInterceptor(foodOptions: foodOptions);
  });

  test('adds disk-cache options to Food recommendation requests', () {
    final categoriesRequest = _apply(
      interceptor,
      ApiEndpoints.recommendationFood,
    );
    final mealsRequest = _apply(
      interceptor,
      '${ApiEndpoints.mealsByCategory}?c=Seafood',
    );

    expect(categoriesRequest.extra, containsPair(extraKey, foodOptions));
    expect(mealsRequest.extra, containsPair(extraKey, foodOptions));
  });

  test('does not cache meal details or unrelated requests', () {
    final detailsRequest = _apply(
      interceptor,
      '${ApiEndpoints.mealDetails}?i=52959',
    );
    final homeRequest = _apply(interceptor, ApiEndpoints.muscles);

    expect(detailsRequest.extra, isEmpty);
    expect(homeRequest.extra, isEmpty);
  });
}

RequestOptions _apply(SmartCacheInterceptor interceptor, String url) {
  final options = RequestOptions(path: url);
  interceptor.onRequest(options, RequestInterceptorHandler());
  return options;
}
