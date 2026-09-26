class CheckoutModel {
  const CheckoutModel({
    required this.id,
    this.code = '',
    required this.total,
    required this.status,
    this.address,
    this.paymentMethod,
    this.latitude,
    this.longitude,
  });

  final int id;
  final String code;
  final double total;
  final String status;
  final String? address;
  final String? paymentMethod;
  final double? latitude;
  final double? longitude;

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['order_id'] ?? json['orderId'] ?? 0;
    final rawCode =
        (json['code'] ??
                json['order_number'] ??
                json['order_code'] ??
                json['number'] ??
                rawId)
            .toString();
    final rawTotal =
        json['total'] ?? json['amount'] ?? json['grand_total'] ?? 0;
    final rawStatus = json['status'] ?? json['state'] ?? 'pending';

    return CheckoutModel(
      id: int.tryParse(rawId.toString()) ?? 0,
      code: rawCode,
      total: double.tryParse(rawTotal.toString()) ?? 0,
      status: rawStatus.toString(),
      address: (json['address'] ?? json['shipping_address'])?.toString(),
      paymentMethod: (json['payment_method'] ?? json['paymentMethod'])
          ?.toString(),
      latitude: double.tryParse(
        (json['latitude'] ?? json['lat'])?.toString() ?? '',
      ),
      longitude: double.tryParse(
        (json['longitude'] ?? json['lng'])?.toString() ?? '',
      ),
    );
  }
}
