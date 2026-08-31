import 'package:buy_verse_app/presentation_layer/admin_version/state_management/admin_models/admin_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    final List<Order> dummyOrders = [
      const Order(
        id: '1001',
        customer: 'John Doe',
        date: '2023-10-25',
        items: '3 items',
        payment: 'Credit Card',
        price: '450',
        status: 'Delivered',
        statusColor: 'green',
      ),
      const Order(
        id: '1002',
        customer: 'Jane Smith',
        date: '2023-10-26',
        items: '1 item',
        payment: 'PayPal',
        price: '120',
        status: 'Pending',
        statusColor: 'orange',
      ),
    ];

    on<GetOrders>((event, emit) {
      emit(OrderLoading());
      emit(OrderLoaded(List.from(dummyOrders)));
    });

    on<UpdateOrderStatus>((event, emit) {
      if (state is OrderLoaded) {
        final orders = (state as OrderLoaded).orders.map((o) {
          if (o.id == event.orderId) {
            return Order(
              id: o.id,
              customer: o.customer,
              date: o.date,
              items: o.items,
              payment: o.payment,
              price: o.price,
              status: event.newStatus,
              statusColor: event.newStatus == 'Delivered' ? 'green' : 'orange',
            );
          }
          return o;
        }).toList();
        emit(OrderLoaded(orders));
      }
    });
  }
}
