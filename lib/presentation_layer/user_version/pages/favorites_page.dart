import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data_layer/user/user_models/product_model.dart';
import '../../../data_layer/user/user_models/product_remote_data_source.dart';
import '../../admin_version/pages/product_pages/products/product_details.dart';
import '../widgets/shop_bottom_navigation.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key, this.authToken});

  final String? authToken;

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<ProductModel>> _productsFuture;
  Set<int> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadProducts();
  }

  /// **************************************************************************
  Future<List<ProductModel>> _loadProducts() async {
    final prefs = await SharedPreferences.getInstance();

    final token = widget.authToken ?? prefs.getString('auth_token');

    _favoriteIds = (prefs.getStringList('favorite_product_ids') ?? [])
        .map(int.tryParse)
        .whereType<int>()
        .toSet();

    return ProductRemoteDataSource().getProducts(token: token);
  }

  /// **************************************************************************
  Future<void> _toggleFavorite(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (!_favoriteIds.add(product.id)) {
        _favoriteIds.remove(product.id);
      }
    });
    await prefs.setStringList(
      'favorite_product_ids',
      _favoriteIds.map((id) => id.toString()).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: FutureBuilder<List<ProductModel>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Unable to load favorites: ${snapshot.error}'),
            );
          }
          final products = snapshot.data!
              .where((product) => _favoriteIds.contains(product.id))
              .toList();
          if (products.isEmpty) {
            return const Center(child: Text('No favorite products yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                child: ListTile(
                  leading: product.image == null || product.image!.isEmpty
                      ? const Icon(Icons.shopping_bag_outlined)
                      : Image.network(
                          product.image!,
                          width: 56,
                          fit: BoxFit.cover,
                        ),
                  title: Text(product.name),
                  subtitle: Text('${product.price.toStringAsFixed(2)} EGP'),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => _toggleFavorite(product),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsPage(
                        slug: product.slug ?? product.id.toString(),
                        product: product,
                        authToken: widget.authToken,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const ShopBottomNavigation(currentIndex: 1),
    );
  }
}
