import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class SmartCacheInterceptor extends Interceptor {
  final CacheOptions homeOptions;

  SmartCacheInterceptor({required this.homeOptions});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  // static final _homeSegment = Uri.parse(Endpoints.home).path;
}
