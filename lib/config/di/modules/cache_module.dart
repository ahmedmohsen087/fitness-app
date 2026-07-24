import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_file_store/http_cache_file_store.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../cache/smart_cache_interceptor.dart';

@module
abstract class CacheModule {
  @preResolve
  @lazySingleton
  Future<CacheStore> cacheStore() async {
    final directory = await getApplicationSupportDirectory();
    return FileCacheStore('${directory.path}/food_cache');
  }

  @lazySingleton
  SmartCacheInterceptor smartCacheInterceptor(CacheStore store) =>
      SmartCacheInterceptor(
        foodOptions: CacheOptions(
          store: store,
          policy: CachePolicy.forceCache,
          maxStale: const Duration(days: 1),
          hitCacheOnNetworkFailure: true,
        ),
      );

  @lazySingleton
  DioCacheInterceptor dioCacheInterceptor(CacheStore store) =>
      DioCacheInterceptor(
        options: CacheOptions(store: store, policy: CachePolicy.noCache),
      );
}
