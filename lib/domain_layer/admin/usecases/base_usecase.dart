import 'package:dio/dio.dart';

abstract class UseCase<Type, Params> {
  Future<Response> call(Params params);
}

class NoParams {}
