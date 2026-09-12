import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buy_verse_app/domain_layer/user/repositories/orders/order_details_repository.dart';
import 'package:buy_verse_app/data_layer/user/user_models/order.dart';

abstract class OrderDetailsState {}

class OrderDetailsInitial extends OrderDetailsState {}

class OrderDetailsLoading extends OrderDetailsState {}

class OrderDetailsLoaded extends OrderDetailsState {
  OrderDetailsLoaded(this.order);

  final OrderModel order;
}

class OrderDetailsError extends OrderDetailsState {
  OrderDetailsError(this.message);

  final String message;
}

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit(this.repository) : super(OrderDetailsInitial());

  final OrderDetailsRepository repository;

  Future<void> fetchOrderDetails({required int orderId, String? token}) async {
    emit(OrderDetailsLoading());

    try {
      final order =
          await repository.getOrderDetails(orderId: orderId, token: token);
      emit(OrderDetailsLoaded(order));
    } catch (error) {
      emit(OrderDetailsError(error.toString()));
    }
  }
}
