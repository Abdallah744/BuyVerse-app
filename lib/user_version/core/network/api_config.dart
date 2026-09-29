import 'package:dio/dio.dart';

abstract final class ApiConfig {
  static const String baseUrl = 'https://easylearn.devawy.com/api';
  static const String apiKey =
      'wQ9KxY7nP2LrA5FmD8TsV1BhE6JzNc4UyRg3KqXpWoMf7CdSaHt9LeIk2On8GbYu';

  static Dio createDio() {
    final dio = Dio();
    dio.options.headers['x-api-key'] = apiKey;
    dio.options.headers['Accept'] = 'application/json';
    return dio;
  }

  static String authorizationHeader(String token) => 'Bearer $token';
}
