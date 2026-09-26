import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/user/remote_data/order_details_remote_data_source.dart';
import '../../../data_layer/user/user_models/order.dart';
import '../../../domain_layer/user/repositories/orders/order_details_repository_impl.dart';
import '../state_management/orders/order_details_cubit.dart';
import 'payment/payment_page.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.order, this.authToken});

  final OrderModel order;
  final String? authToken;

  @override
  Widget build(BuildContext context) {
    final orderIdentifier = order.code.isNotEmpty ? order.code : order.id;
    return BlocProvider(
      create: (_) => OrderDetailsCubit(
        OrderDetailsRepositoryImpl(
          OrderDetailsRemoteDataSource(authToken: authToken),
        ),
      )..fetchOrderDetails(orderId: orderIdentifier, token: authToken),
      child: _OrderDetailsView(order: order, authToken: authToken),
    );
  }
}

class _OrderDetailsView extends StatelessWidget {
  const _OrderDetailsView({required this.order, this.authToken});

  final OrderModel order;
  final String? authToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Order Details',
          style: TextStyle(
            color: Color(0xFF1B2334),
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1B2334)),
        ),
      ),
      body: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
        builder: (context, state) {
          if (state is OrderDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6047FF)),
            );
          }

          if (state is OrderDetailsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 54,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1B2334),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final details = state is OrderDetailsLoaded ? state.order : order;
          final statusColor = _statusColor(details.status);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: details.imageUrl.trim().isEmpty
                      // إذا كان الرابط فارغاً، نعرض أيقونة بديلة داخل صندوق ثابت
                      ? Container(
                          width: double.infinity,
                          height: 240,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        )
                      // إذا كان هناك رابط، نحاول تحميله مع إضافة errorBuilder
                      : Image.network(
                          details.imageUrl,
                          width: double.infinity,
                          height: 240,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // إذا فشل تحميل الرابط (مثلاً خطأ 404 أو انقطاع نت)
                            return Container(
                              width: double.infinity,
                              height: 240,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        details.productName,
                        style: const TextStyle(
                          color: Color(0xFF1B2334),
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        details.status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (!details.status.toLowerCase().contains('paid') &&
                        !details.status.toLowerCase().contains('delivered'))
                      Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentPage(
                                  orderId: details.code.isNotEmpty
                                      ? details.code
                                      : details.id,
                                  authToken: authToken,
                                  defaultPaymentData: const {
                                    'payment_method': 'cod',
                                  },
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.credit_card),
                            label: const Text('Pay with Stripe'),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Icon(Icons.payment_rounded, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Text(
                      'Total:',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      details.totalAmount,
                      style: const TextStyle(
                        color: Color(0xFF6047FF),
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _DetailRow(
                        label: 'Order number',
                        value: details.orderNumber,
                      ),
                      const Divider(height: 22),
                      _DetailRow(
                        label: 'Items',
                        value:
                            '${details.itemCount} item${details.itemCount > 1 ? 's' : ''}',
                      ),
                      const Divider(height: 22),
                      _DetailRow(label: 'Created', value: details.createdAt),
                      const Divider(height: 22),
                      _DetailRow(
                        label: 'Shipping',
                        value: details.shippingAddress,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _statusColor(String status) {
    final upper = status.toLowerCase();
    if (upper.contains('shipped')) return const Color(0xFF2ECC71);
    if (upper.contains('processing')) return const Color(0xFF6047FF);
    if (upper.contains('cancel')) return const Color(0xFFE74C3C);
    if (upper.contains('delivered')) return const Color(0xFF1ABC9C);
    return const Color(0xFFF39C12);
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF1B2334),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
