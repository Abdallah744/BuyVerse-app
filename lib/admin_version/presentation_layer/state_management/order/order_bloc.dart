import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:buy_verse_app/admin_version/data_layer/admin_models/order.dart';
import 'package:buy_verse_app/admin_version/domain_layer/usecases/base_usecase.dart';
import 'package:buy_verse_app/admin_version/domain_layer/usecases/order/order_usecases.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrdersUseCase getOrdersUseCase;

  OrderBloc(this.getOrdersUseCase) : super(OrderInitial()) {
    on<GetOrders>((event, emit) async {
      emit(OrderLoading());
      try {
        final response = await getOrdersUseCase(NoParams());
        if (response.statusCode == 200) {
          final List<dynamic> data = response.data['data'];
          final orders = data.map((json) {
            return Order(
              id: json['code'] ?? json['id'].toString(),
              customer: json['client']['name'] ?? '',
              date: json['created_at'] ?? '',
              items: '${json['items_count']} items',
              payment: json['payment_method'] ?? '',
              price: json['total_price'].toString(),
              status: json['status'] ?? 'Pending',
              statusColor: json['status'] == 'delivered' ? 'green' : 'orange',
            );
          }).toList();
          emit(OrderLoaded(orders));
        } else {
          emit(const OrderLoaded([]));
        }
      } catch (e) {
        emit(const OrderLoaded([]));
      }
    });
  }
}
