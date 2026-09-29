import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/remote/checkout_remote_data_source.dart';
import '../data/repositories/checkout_repository_impl.dart';
import '../presentation/cubit/checkout_cubit.dart';
import '../../pages/payment_page.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({
    super.key,
    this.authToken,
    this.productIds = const [],
    this.quantities = const [],
    this.prices = const [],
  });

  final String? authToken;
  final List<int> productIds;
  final List<int> quantities;
  final List<double> prices;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CheckoutCubit(CheckoutRepositoryImpl(CheckoutRemoteDataSource())),
      child: _CheckoutView(
        authToken: authToken,
        productIds: productIds,
        quantities: quantities,
        prices: prices,
      ),
    );
  }
}

class _CheckoutView extends StatefulWidget {
  const _CheckoutView({
    this.authToken,
    required this.productIds,
    required this.quantities,
    required this.prices,
  });

  final String? authToken;
  final List<int> productIds;
  final List<int> quantities;
  final List<double> prices;

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController paymentController =
      TextEditingController(text: 'stripe');

  @override
  void dispose() {
    addressController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    paymentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.prices.fold<double>(0, (sum, value) => sum + value);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Color(0xFF1B2334),
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
      ),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => PaymentPage(
                  orderId: state.checkout.id,
                  authToken: widget.authToken,
                  defaultPaymentData: {
                    'payment_method': 'stripe',
                    'amount': state.checkout.total,
                  },
                ),
              ),
            );
          }
          if (state is CheckoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isSubmitting = state is CheckoutSubmitting;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery details',
                  style: TextStyle(
                    color: Color(0xFF1B2334),
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: latitudeController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Latitude',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: longitudeController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Longitude',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: paymentController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Payment method (Stripe)',
                    prefixIcon: Icon(Icons.credit_card),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order summary',
                        style: TextStyle(
                          color: Color(0xFF1B2334),
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Products: ${widget.productIds.length}',
                        style: const TextStyle(
                            color: Color(0xFF5E6475), fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFF6047FF),
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: isSubmitting
                        ? null
                        : () {
                            final address = addressController.text.trim();
                            final latitude = double.tryParse(
                                    latitudeController.text.trim()) ??
                                0;
                            final longitude = double.tryParse(
                                    longitudeController.text.trim()) ??
                                0;
                            if (address.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Address is required'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            context.read<CheckoutCubit>().createOrder(
                                  productIds: widget.productIds,
                                  quantities: widget.quantities,
                                  prices: widget.prices,
                                  address: address,
                                  latitude: latitude,
                                  longitude: longitude,
                                  paymentMethod: 'stripe',
                                  token: widget.authToken,
                                );
                          },
                    icon: isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_circle_outline),
                    label:
                        Text(isSubmitting ? 'Placing order...' : 'Place Order'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6047FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
