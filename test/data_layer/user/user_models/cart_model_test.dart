import 'package:buy_verse_app/data_layer/user/user_models/cart_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reads product name and price from nested product data', () {
    final item = CartModel.fromJson({
      'id': 10,
      'quantity': 2,
      'product': {'id': 7, 'name': 'Coffee Maker', 'price': 125.5},
    });

    expect(item.productId, 7);
    expect(item.productName, 'Coffee Maker');
    expect(item.price, 125.5);
    expect(item.total, 251);
  });
}
