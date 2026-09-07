class CartModel {
  const CartModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    this.quantity = 1,
    this.price = 0,
    this.total = 0,
  });

  final int id;
  final int productId;
  final String productName;
  final String? productImage;
  final int quantity;
  final double price;
  final double total;

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['cart_id'] ?? json['cartId'] ?? 0;
    final rawProductId =
        json['product_id'] ?? json['productId'] ?? json['product'] ?? 0;
    final productName =
        json['product_name'] ??
        json['productName'] ??
        json['name'] ??
        json['title'] ??
        'Product';
    final rawQuantity = json['quantity'] ?? json['qty'] ?? 1;
    final rawPrice =
        json['price'] ??
        json['amount'] ??
        json['product_price'] ??
        json['unit_price'] ??
        0;
    final rawTotal = json['total'] ?? json['line_total'] ?? json['subtotal'] ?? 0;

    final productIdValue = int.tryParse(rawProductId.toString()) ?? 0;
    final priceValue = double.tryParse(rawPrice.toString()) ?? 0;
    final totalValue = double.tryParse(rawTotal.toString()) ??
        (priceValue * (int.tryParse(rawQuantity.toString()) ?? 1));

    return CartModel(
      id: int.tryParse(rawId.toString()) ?? 0,
      productId: productIdValue,
      productName: productName.toString(),
      productImage: (json['image'] ?? json['image_url'] ?? json['product_image'])
          ?.toString(),
      quantity: int.tryParse(rawQuantity.toString()) ?? 1,
      price: priceValue,
      total: totalValue,
    );
  }

  static List<CartModel> fromList(dynamic rawData) {
    if (rawData is List) {
      return rawData
          .whereType<Map<String, dynamic>>()
          .map(CartModel.fromJson)
          .toList();
    }

    if (rawData is Map<String, dynamic>) {
      final keys = ['data', 'cart', 'items', 'products', 'result'];
      for (final key in keys) {
        final value = rawData[key];
        if (value is List) {
          return value
              .whereType<Map<String, dynamic>>()
              .map(CartModel.fromJson)
              .toList();
        }
        if (value is Map<String, dynamic>) {
          final nested = value['data'] ?? value['items'] ?? value['products'];
          if (nested is List) {
            return nested
                .whereType<Map<String, dynamic>>()
                .map(CartModel.fromJson)
                .toList();
          }
        }
      }
    }

    return const [];
  }
}
