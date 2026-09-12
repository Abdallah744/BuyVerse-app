// ignore_for_file: unnecessary_null_comparison

import 'package:buy_verse_app/data_layer/user/services/shared_preferences_service.dart';
import 'package:buy_verse_app/data_layer/user/user_models/product_details_remote_data_source.dart';
import 'package:buy_verse_app/data_layer/user/user_models/product_model.dart';
import 'package:buy_verse_app/domain_layer/user/repositories/products/product_details_repository_impl.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/proudcts/cart_cubit.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/proudcts/product_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/user/remote_data/cart_remote_data_source.dart';
import '../../../domain_layer/user/repositories/products/cart_repository_impl.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({
    super.key,
    required this.slug,
    this.authToken,
    this.product,
  });

  final String slug;
  final String? authToken;
  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductDetailsCubit(
            ProductDetailsRepositoryImpl(ProductDetailsRemoteDataSource()),
          )..fetchProductBySlug(slug: slug, token: authToken),
        ),
        BlocProvider(
          create: (_) => CartCubit(CartRepositoryImpl(CartRemoteDataSource())),
        ),
      ],
      child: _ProductDetailsView(
        authToken: authToken,
        initialProduct: product,
        slug: slug,
      ),
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  const _ProductDetailsView({
    this.authToken,
    this.initialProduct,
    required this.slug,
  });

  final String? authToken;
  final ProductModel? initialProduct;
  final String slug;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1B2334)),
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: Color(0xFF1B2334),
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
      ),
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6047FF)),
            );
          }

          if (state is ProductDetailsError) {
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
                      onPressed: () => context
                          .read<ProductDetailsCubit>()
                          .fetchProductBySlug(slug: slug, token: authToken),
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

          final product =
              initialProduct ??
              (state is ProductDetailsLoaded ? state.product : null);

          if (product == null) {
            return const Center(child: Text('Product not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child:
                      product.image != null &&
                          (product.image?.isNotEmpty ?? false)
                      ? Image.network(
                          product.image ?? '',
                          height: 280,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox(
                            height: 280,
                            child: Center(
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                size: 60,
                                color: Color(0xFF6047FF),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(
                          height: 280,
                          child: Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 60,
                              color: Color(0xFF6047FF),
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 22),
                Text(
                  product.name,
                  style: const TextStyle(
                    color: Color(0xFF1B2334),
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6047FF).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF6047FF),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Description',
                  style: TextStyle(
                    color: Color(0xFF1B2334),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description ??
                      'No description available for this product.',
                  style: const TextStyle(
                    color: Color(0xFF5E6475),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                if (product.slug != null && (product.slug?.isNotEmpty ?? false))
                  Text(
                    'Slug: ${product.slug ?? ''}',
                    style: const TextStyle(
                      color: Color(0xFF5E6475),
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {
                      final productId = product.id;
                      if (productId != null) {
                        try {
                          await context.read<CartCubit>().addToCart(
                            productId: productId,
                            quantity: 1,
                            token: authToken,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to cart successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (error) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to add to cart: $error'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Add to Cart'),
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
                const SizedBox(height: 12),
                _FavoriteButton(productId: product.id),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  const _FavoriteButton({required this.productId});

  final int productId;

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final ids = await SharedPreferencesService.instance.getFavoriteProductIds();
    if (mounted) {
      setState(() => _isFavorite = ids.contains(widget.productId.toString()));
    }
  }

  Future<void> _toggle() async {
    final ids =
        (await SharedPreferencesService.instance.getFavoriteProductIds())
            .toSet();
    if (_isFavorite) {
      ids.remove(widget.productId.toString());
    } else {
      ids.add(widget.productId.toString());
    }
    await SharedPreferencesService.instance.setFavoriteProductIds(ids.toList());
    if (mounted) {
      setState(() => _isFavorite = !_isFavorite);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: _toggle,
      icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
      label: Text(_isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
    );
  }
}
