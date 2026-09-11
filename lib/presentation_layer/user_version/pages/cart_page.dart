import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/user/remote_data/cart_remote_data_source.dart';
import '../../../domain_layer/user/repositories/products/cart_repository_impl.dart';
import '../state_management/proudcts/cart_cubit.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key, this.authToken});

  final String? authToken;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CartCubit(CartRepositoryImpl(CartRemoteDataSource()))
            ..fetchCart(token: authToken),
      child: _CartView(authToken: authToken),
    );
  }
}

class _CartView extends StatelessWidget {
  const _CartView({this.authToken});

  final String? authToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Cart',
          style: TextStyle(
            color: Color(0xFF1B2334),
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6047FF)),
            );
          }

          if (state is CartError) {
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
                        color: Color(0xFF1B2334),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: () =>
                          context.read<CartCubit>().fetchCart(token: authToken),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF6047FF),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CartEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF1B2334),
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }

          if (state is CartLoaded) {
            final items = state.items;
            final total = items.fold<double>(
              0,
              (sum, item) => sum + item.total,
            );

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(18),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child:
                                  item.productImage != null &&
                                      item.productImage!.isNotEmpty
                                  ? Image.network(
                                      item.productImage!,
                                      width: 72,
                                      height: 72,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const SizedBox(
                                            width: 72,
                                            height: 72,
                                            child: Icon(
                                              Icons.shopping_bag_outlined,
                                              size: 34,
                                              color: Color(0xFF6047FF),
                                            ),
                                          ),
                                    )
                                  : const SizedBox(
                                      width: 72,
                                      height: 72,
                                      child: Icon(
                                        Icons.shopping_bag_outlined,
                                        size: 34,
                                        color: Color(0xFF6047FF),
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF1B2334),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '\$${item.total.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Color(0xFF6047FF),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (item.quantity > 1) {
                                      context.read<CartCubit>().updateCartItem(
                                        productId: item.productId,
                                        quantity: item.quantity - 1,
                                        token: authToken,
                                      );
                                    } else {
                                      context.read<CartCubit>().removeFromCart(
                                        productId: item.productId,
                                        token: authToken,
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    color: Color(0xFF1B2334),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.read<CartCubit>().updateCartItem(
                                      productId: item.productId,
                                      quantity: item.quantity + 1,
                                      token: authToken,
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.read<CartCubit>().removeFromCart(
                                      productId: item.productId,
                                      token: authToken,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          color: Color(0xFF1B2334),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFF6047FF),
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('Loading cart...'));
        },
      ),
      bottomNavigationBar: null,
    );
  }
}
