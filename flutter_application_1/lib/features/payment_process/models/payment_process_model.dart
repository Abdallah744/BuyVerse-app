class PaymentProcessModel {
  const PaymentProcessModel({
    required this.status,
    this.message,
    this.reference,
    this.amount,
  });

  final String status;
  final String? message;
  final String? reference;
  final double? amount;

  factory PaymentProcessModel.fromJson(Map<String, dynamic> json) {
    final rawStatus =
        json['status'] ?? json['state'] ?? json['payment_status'] ?? 'success';
    final rawAmount = json['amount'] ?? json['total'] ?? json['paid_amount'];
    final rawReference = json['reference'] ?? json['transaction_id'] ?? json['payment_id'];

    return PaymentProcessModel(
      status: rawStatus.toString(),
      message: (json['message'] ?? json['details'])?.toString(),
      reference: rawReference?.toString(),
      amount: double.tryParse(rawAmount?.toString() ?? ''),
    );
  }
}
