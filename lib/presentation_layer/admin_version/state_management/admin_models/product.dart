import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String category;
  final String price;
  final String quantity;
  final String description;
  final String image;
  final bool isVisible;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.description,
    required this.image,
    this.isVisible = true,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    price,
    quantity,
    description,
    image,
    isVisible,
  ];
}
