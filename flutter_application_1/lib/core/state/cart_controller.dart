import 'package:flutter/foundation.dart';

import '../models/product.dart';

/// One product + quantity line inside the cart.
class CartLineItem {
  CartLineItem({required this.product, required this.quantity});

  final Product product;
  int quantity;

  double get lineTotal => product.priceEgp * quantity;
}

/// Holds the cart contents for the whole app session.
///
/// A plain [ChangeNotifier] rather than a state-management package: the
/// cart only needs to be read/written from a handful of screens, and
/// [ChangeNotifier] + [CartScope] (an [InheritedNotifier]) covers that
/// without adding a dependency. Swap this for Provider/Riverpod/Bloc in
/// the real app if it already uses one of those.
class CartController extends ChangeNotifier {
  final List<CartLineItem> _items = [];

  List<CartLineItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.lineTotal);

  void addProduct(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartLineItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
