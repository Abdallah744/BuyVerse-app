import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final String id;
  final String customer;
  final String date;
  final String items;
  final String payment;
  final String price;
  final String status;
  final String statusColor;

  const Order({
    required this.id,
    required this.customer,
    required this.date,
    required this.items,
    required this.payment,
    required this.price,
    required this.status,
    required this.statusColor,
  });

  @override
  List<Object?> get props => [
    id,
    customer,
    date,
    items,
    payment,
    price,
    status,
    statusColor,
  ];
}
