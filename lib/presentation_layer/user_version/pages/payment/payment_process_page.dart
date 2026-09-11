import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/user/repositories/payment/payment_process_repository_impl.dart';
import '../../../../data_layer/user/remote_data/payment_process_remote_data_source.dart';
import '../../state_management/payment/payment_process_cubit.dart';

class PaymentProcessPage extends StatelessWidget {
  const PaymentProcessPage({
    super.key,
    this.authToken,
    this.defaultPayload = const {},
  });

  final String? authToken;
  final Map<String, dynamic> defaultPayload;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentProcessCubit(
        PaymentProcessRepositoryImpl(PaymentProcessRemoteDataSource()),
      ),
      child: _PaymentProcessView(
        authToken: authToken,
        defaultPayload: defaultPayload,
      ),
    );
  }
}

class _PaymentProcessView extends StatefulWidget {
  const _PaymentProcessView({this.authToken, this.defaultPayload = const {}});

  final String? authToken;
  final Map<String, dynamic> defaultPayload;

  @override
  State<_PaymentProcessView> createState() => _PaymentProcessViewState();
}

class _PaymentProcessViewState extends State<_PaymentProcessView> {
  final TextEditingController methodController = TextEditingController(
    text: 'cash',
  );
  final TextEditingController amountController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();

  @override
  void dispose() {
    methodController.dispose();
    amountController.dispose();
    referenceController.dispose();
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
          'Payment Process',
          style: TextStyle(
            color: Color(0xFF1B2334),
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
      ),
      body: BlocConsumer<PaymentProcessCubit, PaymentProcessState>(
        listener: (context, state) {
          if (state is PaymentProcessSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.paymentProcess.message ?? 'Payment process completed',
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is PaymentProcessError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isSubmitting = state is PaymentProcessSubmitting;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Process payment',
                  style: TextStyle(
                    color: Color(0xFF1B2334),
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: methodController,
                  decoration: const InputDecoration(
                    labelText: 'Payment method',
                    hintText: 'cash / card / wallet',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: referenceController,
                  decoration: const InputDecoration(
                    labelText: 'Reference',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: isSubmitting
                        ? null
                        : () {
                            final payload = {
                              ...widget.defaultPayload,
                              'payment_method':
                                  methodController.text.trim().isEmpty
                                  ? 'cash'
                                  : methodController.text.trim(),
                              'amount':
                                  double.tryParse(
                                    amountController.text.trim(),
                                  ) ??
                                  0,
                              'reference': referenceController.text.trim(),
                            };

                            context.read<PaymentProcessCubit>().processPayment(
                              paymentPayload: payload,
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
                        : const Icon(Icons.credit_card_rounded),
                    label: Text(
                      isSubmitting ? 'Processing...' : 'Process Payment',
                    ),
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
