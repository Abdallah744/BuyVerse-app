import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

import 'cache_helper.dart';

class DioHelper {
  static late Dio dio;
  static String? token;

  static Future<void> init() async {
    token = CacheHelper.getData(key: 'token');

    final dir = await getTemporaryDirectory();
    final cacheStore = HiveCacheStore(dir.path);
    final cacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.refreshForceCache,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(days: 7),
      priority: CachePriority.high,
    );

    dio = Dio(
      BaseOptions(
        baseUrl: dotenv.get('BASE_URL'),
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-api-key': dotenv.get('API_KEY'),
        },
      ),
    );

    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Priority 1: Use the static token in memory
          // Priority 2: Use the token from cache if static is null
          final currentToken = token ?? CacheHelper.getData(key: 'token');

          if (currentToken != null) {
            options.headers['Authorization'] = 'Bearer $currentToken';
            print(
              'DEBUG: [DIO] Authorization Header added using token: ${currentToken.substring(0, 10)}...',
            );
          } else {
            print(
              'DEBUG: [DIO] No token available for request to ${options.path}',
            );
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            print(
              'DEBUG: [DIO] 401 Unauthorized - Message: ${e.response?.data['message']}',
            );
          }

          // Retry Mechanism for network errors
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.sendTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionError) {
            
            // Only retry 3 times max
            int retries = e.requestOptions.extra['retries'] ?? 0;
            if (retries < 3) {
              e.requestOptions.extra['retries'] = retries + 1;
              print('DEBUG: [DIO] Retrying request (${retries + 1}/3)...');
              return handler.resolve(await dio.fetch(e.requestOptions));
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    dynamic data,
    Map<String, dynamic>? query,
  }) async {
    return dio.post(url, queryParameters: query, data: data);
  }

  static Future<Response> putData({
    required String url,
    dynamic data,
    Map<String, dynamic>? query,
  }) async {
    return dio.put(url, queryParameters: query, data: data);
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    return dio.delete(url, queryParameters: query);
  }
}
