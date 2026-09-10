import 'package:dio/dio.dart';
import '../../../../../data_layer/admin/repositories/order_repository.dart';
import '../base_usecase.dart';

class GetOrdersUseCase extends UseCase<Response, NoParams> {
  final OrderRepository repository;
  GetOrdersUseCase(this.repository);
  @override
  Future<Response> call(NoParams params) async => await repository.getOrders();
}
