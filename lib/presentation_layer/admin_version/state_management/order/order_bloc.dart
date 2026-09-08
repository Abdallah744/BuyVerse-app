import 'package:buy_verse_app/core_layer/admin/helpers/dio_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/admin/admin_models/order.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<GetOrders>((event, emit) async {
      emit(OrderLoading());
      try {
        final response = await DioHelper.getData(url: '/admin/orders');
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
