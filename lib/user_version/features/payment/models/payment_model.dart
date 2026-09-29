class PaymentModel {
  const PaymentModel({
    required this.status,
    this.message,
    this.orderId,
    this.transactionId,
  });

  final String status;
  final String? message;
  final int? orderId;
  final String? transactionId;

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    final rawStatus =
        json['status'] ?? json['state'] ?? json['payment_status'] ?? 'success';
    final rawOrderId = json['order_id'] ?? json['orderId'] ?? json['id'];
    final rawTransactionId =
        json['transaction_id'] ?? json['transactionId'] ?? json['payment_id'];

    return PaymentModel(
      status: rawStatus.toString(),
      message: (json['message'] ?? json['details'])?.toString(),
      orderId: int.tryParse(rawOrderId?.toString() ?? ''),
      transactionId: rawTransactionId?.toString(),
    );
  }
}
