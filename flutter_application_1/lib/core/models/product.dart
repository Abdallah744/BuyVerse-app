import 'package:flutter/material.dart';

/// A catalog product. Lives in `core/models` (not the shop feature)
/// because it's a genuinely cross-cutting concept — the cart, checkout,
/// and order-success screens all need it too.
class Product {
  const Product({
    required this.id,
    required this.category,
    required this.name,
    required this.priceEgp,
    required this.storeName,
    required this.emoji,
    required this.gradient,
    this.description = '',
    this.stockCount = 0,
  });

  final String id;
  final String category;
  final String name;
  final double priceEgp;
  final String storeName;
  final String emoji;
  final List<Color> gradient;
  final String description;
  final int stockCount;

  bool get inStock => stockCount > 0;
}
