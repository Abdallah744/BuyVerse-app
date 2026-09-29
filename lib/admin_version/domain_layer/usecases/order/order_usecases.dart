import 'package:dio/dio.dart';
import 'package:buy_verse_app/admin_version/data_layer/repositories/order_repository.dart';
import '../base_usecase.dart';

class GetOrdersUseCase extends UseCase<Response, NoParams> {
  final OrderRepository repository;
  GetOrdersUseCase(this.repository);
  @override
  Future<Response> call(NoParams params) async => await repository.getOrders();
}
