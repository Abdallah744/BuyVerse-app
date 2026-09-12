import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/user/remote_data/order_remote_data_source.dart';
import '../../../domain_layer/user/repositories/orders/order_repository_impl.dart';
import '../pages/order_details_page.dart';
import '../state_management/orders/order_cubit.dart';
import '../widgets/logout_button.dart';
import '../widgets/order_card.dart';
import '../widgets/shop_bottom_navigation.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key, this.authToken});

  final String? authToken;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderCubit(
        OrderRepositoryImpl(OrderRemoteDataSource(authToken: authToken)),
      )..fetchOrders(token: authToken),
      child: _OrdersView(authToken: authToken),
    );
  }
}

class _OrdersView extends StatelessWidget {
  const _OrdersView({required this.authToken});

  final String? authToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Orders',
          style: TextStyle(
            color: Color(0xFF1B2334),
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.filter_list_rounded, color: Color(0xFF1B2334)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: LogoutButton(authToken: authToken),
          ),
        ],
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6900)),
            );
          }

          if (state is OrderError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
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
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: () => context.read<OrderCubit>().fetchOrders(
                        token: authToken,
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6900),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is OrderLoaded) {
            final orders = state.orders;

            if (orders.isEmpty) {
              return const Center(
                child: Text(
                  'No orders found',
                  style: TextStyle(
                    color: Color(0xFF1B2334),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(
                  order: order,
                  authToken: authToken,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsPage(
                          order: order,
                          authToken: authToken,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }

          return const Center(child: Text('Fetching orders...'));
        },
      ),
      bottomNavigationBar: const ShopBottomNavigation(currentIndex: 3),
    );
  }
}
