import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/user/repositories/orders/order_repository_impl.dart';
import '../../../../data_layer/user/user_models/order.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  OrderLoaded(this.orders);

  final List<OrderModel> orders;
}

class OrderError extends OrderState {
  OrderError(this.message);

  final String message;
}

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this.repository) : super(OrderInitial());

  final OrderRepositoryImpl repository;

  Future<void> fetchOrders({String? token}) async {
    emit(OrderLoading());

    try {
      final orders = await repository.getOrders(token: token);
      emit(OrderLoaded(orders));
    } catch (error) {
      emit(OrderError(error.toString()));
    }
  }
}
