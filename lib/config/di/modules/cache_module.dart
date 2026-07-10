import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:injectable/injectable.dart';

import '../../cache/smart_cache_interceptor.dart';

@module
abstract class CacheModule {
  @lazySingleton
  CacheStore get cacheStore => MemCacheStore();

  @lazySingleton
  SmartCacheInterceptor smartCacheInterceptor(CacheStore store) =>
      SmartCacheInterceptor(
        homeOptions: CacheOptions(
          store: store,
          policy: CachePolicy.request,
          maxStale: const Duration(hours: 1),
          hitCacheOnErrorCodes: const [401, 403],
        ),
      );

  @lazySingleton
  DioCacheInterceptor dioCacheInterceptor(CacheStore store) =>
      DioCacheInterceptor(
        options: CacheOptions(store: store, policy: CachePolicy.noCache),
      );
}
