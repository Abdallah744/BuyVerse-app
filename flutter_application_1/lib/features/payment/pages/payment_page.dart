import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/remote/payment_remote_data_source.dart';
import '../data/repositories/payment_repository_impl.dart';
import '../presentation/cubit/payment_cubit.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({
    super.key,
    required this.orderId,
    this.authToken,
    this.defaultPaymentData = const {},
  });

  final int orderId;
  final String? authToken;
  final Map<String, dynamic> defaultPaymentData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PaymentCubit(PaymentRepositoryImpl(PaymentRemoteDataSource())),
      child: _PaymentView(
        orderId: orderId,
        authToken: authToken,
        defaultPaymentData: defaultPaymentData,
      ),
    );
  }
}

class _PaymentView extends StatefulWidget {
  const _PaymentView({
    required this.orderId,
    this.authToken,
    this.defaultPaymentData = const {},
  });

  final int orderId;
  final String? authToken;
  final Map<String, dynamic> defaultPaymentData;

  @override
  State<_PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<_PaymentView> {
  final TextEditingController methodController =
      TextEditingController(text: 'stripe');
  final TextEditingController detailsController =
      TextEditingController(text: '');

  @override
  void dispose() {
    methodController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Color(0xFF1B2334),
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
      ),
      body: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.payment.message ?? 'Payment completed successfully',
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is PaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isProcessing = state is PaymentProcessing;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select payment method',
                  style: TextStyle(
                    color: Color(0xFF1B2334),
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: methodController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Payment method',
                    hintText: 'Stripe',
                    prefixIcon: Icon(Icons.credit_card),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: detailsController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Payment details',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: isProcessing
                        ? null
                        : () {
                            final data = {
                              ...widget.defaultPaymentData,
                              'payment_method': 'stripe',
                              'details': detailsController.text.trim(),
                            };

                            context.read<PaymentCubit>().payOrder(
                                  orderId: widget.orderId,
                                  paymentData: data,
                                  token: widget.authToken,
                                );
                          },
                    icon: isProcessing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.payment_rounded),
                    label: Text(isProcessing ? 'Processing...' : 'Pay Now'),
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
