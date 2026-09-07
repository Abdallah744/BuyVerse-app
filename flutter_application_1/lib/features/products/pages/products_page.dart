import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/remote/product_remote_data_source.dart';
import '../data/repositories/product_repository_impl.dart';
import '../pages/product_details_page.dart';
import '../presentation/cubit/product_cubit.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key, this.authToken});

  final String? authToken;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductCubit(ProductRepositoryImpl(ProductRemoteDataSource()))
            ..fetchProducts(token: authToken),
      child: _ProductsView(authToken: authToken),
    );
  }
}

class _ProductsView extends StatelessWidget {
  const _ProductsView({this.authToken});

  final String? authToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Products',
          style: TextStyle(
            color: Color(0xFF1B2334),
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6047FF)),
            );
          }

          if (state is ProductError) {
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
                      onPressed: () => context
                          .read<ProductCubit>()
                          .fetchProducts(token: authToken),
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

          if (state is ProductEmpty) {
            return const Center(
              child: Text(
                'No products found',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1B2334),
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          if (state is ProductLoaded) {
            final products = state.products;
            return GridView.builder(
              padding: const EdgeInsets.all(18),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.78,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final priceText = '\$${product.price.toStringAsFixed(2)}';
                final productSlug = product.slug ?? product.id.toString();
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsPage(
                          slug: productSlug,
                          authToken: authToken,
                          product: product,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
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
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(22),
                            ),
                            child: product.image != null &&
                                    product.image!.isNotEmpty
                                ? Image.network(
                                    product.image!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 52,
                                      color: Color(0xFF6047FF),
                                    ),
                                  )
                                : const Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 52,
                                    color: Color(0xFF6047FF),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF1B2334),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              if (product.description != null &&
                                  product.description!.isNotEmpty)
                                Text(
                                  product.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF5E6475),
                                    fontSize: 12,
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Text(
                                priceText,
                                style: const TextStyle(
                                  color: Color(0xFF6047FF),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Fetching products...'));
        },
      ),
    );
  }
}
