import 'package:dio/dio.dart';

import 'cache_helper.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://easylearn.devawy.com/api',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key':
              'wQ9KxY7nP2LrA5FmD8TsV1BhE6JzNc4UyRg3KqXpWoMf7CdSaHt9LeIk2On8GbYu',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          String? token = CacheHelper.getData(key: 'token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    if (token != null) dio.options.headers['Authorization'] = 'Bearer $token';
    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    dynamic data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    if (token != null) dio.options.headers['Authorization'] = 'Bearer $token';
    return dio.post(url, queryParameters: query, data: data);
  }

  static Future<Response> putData({
    required String url,
    dynamic data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    if (token != null) dio.options.headers['Authorization'] = 'Bearer $token';
    return dio.put(url, queryParameters: query, data: data);
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    if (token != null) dio.options.headers['Authorization'] = 'Bearer $token';
    return dio.delete(url, queryParameters: query);
  }
}
