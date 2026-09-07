class OrderModel {
  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.productName,
    required this.imageUrl,
    required this.itemCount,
    required this.shippingAddress,
  });

  final int id;
  final String orderNumber;
  final String status;
  final String totalAmount;
  final String createdAt;
  final String productName;
  final String imageUrl;
  final int itemCount;
  final String shippingAddress;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final orderId = data['id'] ?? data['order_id'] ?? 0;
    final number = (data['order_number'] ?? data['number'] ?? data['orderNo'] ?? '#$orderId')
        .toString();
    final status = (data['status'] ?? 'pending').toString();
    final amount = (data['total_amount'] ?? data['total'] ?? data['amount'] ?? '0.00').toString();
    final createdAt = (data['created_at'] ?? data['createdAt'] ?? DateTime.now().toIso8601String())
        .toString();
    final productName = (data['product_name'] ?? data['productName'] ?? data['title'] ?? 'Product')
        .toString();
    final imageUrl = (data['image_url'] ?? data['imageUrl'] ?? data['image'] ??
            'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=800&q=80')
        .toString();
    final itemCount = int.tryParse((data['item_count'] ?? data['items_count'] ?? data['quantity'] ?? '1').toString()) ?? 1;
    final shippingAddress = (data['shipping_address'] ?? data['address'] ?? 'Not available').toString();

    return OrderModel(
      id: int.tryParse(orderId.toString()) ?? 0,
      orderNumber: number,
      status: status,
      totalAmount: amount,
      createdAt: createdAt,
      productName: productName,
      imageUrl: imageUrl,
      itemCount: itemCount,
      shippingAddress: shippingAddress,
    );
  }

  static List<OrderModel> fromList(dynamic rawData) {
    if (rawData is List) {
      return rawData
          .whereType<Map<String, dynamic>>()
          .map(OrderModel.fromJson)
          .toList();
    }

    if (rawData is Map<String, dynamic>) {
      final list = rawData['data'];
      if (list is List) {
        return list
            .whereType<Map<String, dynamic>>()
            .map(OrderModel.fromJson)
            .toList();
      }
      if (rawData['orders'] is List) {
        return rawData['orders']
            .whereType<Map<String, dynamic>>()
            .map(OrderModel.fromJson)
            .toList();
      }
      if (rawData['result'] is List) {
        return rawData['result']
            .whereType<Map<String, dynamic>>()
            .map(OrderModel.fromJson)
            .toList();
      }
    }

    return const [];
  }

  static List<OrderModel> mockOrders() {
    return const [
      OrderModel(
        id: 1,
        orderNumber: '#1024',
        status: 'Shipped',
        totalAmount: '\$249.00',
        createdAt: '2026-09-01',
        productName: 'Smart Watch Pro',
        imageUrl: 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?auto=format&fit=crop&w=800&q=80',
        itemCount: 1,
        shippingAddress: 'Cairo, Egypt',
      ),
      OrderModel(
        id: 2,
        orderNumber: '#1028',
        status: 'Processing',
        totalAmount: '\$159.00',
        createdAt: '2026-09-04',
        productName: 'Wireless Earbuds',
        imageUrl: 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80',
        itemCount: 2,
        shippingAddress: 'Alexandria, Egypt',
      ),
    ];
  }
}
