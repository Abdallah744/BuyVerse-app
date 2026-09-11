// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core_layer/user/core/theme/theme_mode_scope.dart';
import '../../../data_layer/user/category_repository_impl.dart';
import '../../../data_layer/user/remote_data/category_remote_data_source.dart';
import '../../../data_layer/user/remote_data/profile_remote_data_source.dart';
import '../../../data_layer/user/user_models/category_model.dart';
import '../../../data_layer/user/user_models/product_model.dart';
import '../../../data_layer/user/user_models/product_remote_data_source.dart';
import '../../../data_layer/user/user_models/user_models.dart';
import '../../../domain_layer/user/repositories/products/product_repository_impl.dart';
import '../../admin_version/pages/product_pages/products/product_details.dart';
import '../state_management/auth/auth_cubit.dart';
import '../state_management/category_cubit.dart';
import '../state_management/proudcts/product_cubit.dart';
import '../widgets/shop_bottom_navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.authToken, this.compact = false});

  final String? authToken;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ProductCubit(ProductRepositoryImpl(ProductRemoteDataSource()))
                ..fetchProducts(token: authToken),
        ),
        BlocProvider(
          create: (_) =>
              CategoryCubit(CategoryRepositoryImpl(CategoryRemoteDataSource()))
                ..fetchCategories(token: authToken),
        ),
      ],
      child: _HomeView(authToken: authToken, compact: compact),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({required this.authToken, required this.compact});

  final String? authToken;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _Header(compact: compact, authToken: authToken),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  final categories = state is CategoryLoaded
                      ? state.categories
                      : const <CategoryModel>[];
                  return _CategoryStrip(categories: categories);
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF101828),
                      ),
                    ),
                    BlocBuilder<ProductCubit, ProductState>(
                      builder: (context, state) {
                        final count = state is ProductLoaded
                            ? state.products.length
                            : 0;
                        return Text(
                          '$count items',
                          style: const TextStyle(color: Color(0xFF98A2B3)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF6900),
                      ),
                    ),
                  );
                }
                if (state is ProductError) {
                  return SliverFillRemaining(
                    child: Center(child: Text(state.message)),
                  );
                }
                if (state is! ProductLoaded || state.products.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No products found')),
                  );
                }
                final products = state.products;
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: .72,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _ProductCard(
                        product: product,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailsPage(
                              slug: product.slug ?? product.id.toString(),
                              authToken: authToken,
                              product: product,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ShopBottomNavigation(currentIndex: 0),
    );
  }
}

class Home2Page extends StatelessWidget {
  const Home2Page({super.key, this.authToken});

  final String? authToken;

  @override
  Widget build(BuildContext context) {
    return HomePage(authToken: authToken, compact: true);
  }
}

class _Header extends StatefulWidget {
  const _Header({required this.compact, this.authToken});

  final bool compact;
  final String? authToken;

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  late final Future<UserModels?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<UserModels?> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = widget.authToken ?? prefs.getString('auth_token');
    if (token == null || token.trim().isEmpty) return null;
    try {
      return await ProfileRemoteDataSource().getProfile(token: token);
    } on DioException {
      final savedName = prefs.getString('auth_name');
      if (savedName == null || savedName.trim().isEmpty) return null;
      return UserModels(name: savedName, email: '', phone: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF101828);
    final secondaryColor = isDark
        ? const Color(0xFFB0B0B0)
        : const Color(0xFF98A2B3);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'GOOD MORNING,',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF98A2B3),
                        letterSpacing: .6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final authName = state is AuthSuccess
                            ? state.user.name
                            : null;
                        return FutureBuilder<UserModels?>(
                          future: _profileFuture,
                          builder: (context, snapshot) {
                            final profileName = snapshot.data?.name;
                            final name = (authName ?? profileName ?? 'User')
                                .trim();
                            return Text(
                              name.isEmpty ? 'User' : name,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Toggle dark mode',
                    onPressed: ThemeModeScope.of(context).onToggle,
                    icon: Icon(
                      Theme.of(context).brightness == Brightness.dark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 19,
                    backgroundColor: Color(0xFFFF6900),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: widget.compact
                  ? 'Search products...'
                  : 'Search products...',
              prefixIcon: Icon(Icons.search, color: secondaryColor),
              filled: true,
              fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({required this.categories});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Categories',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 25),
              child: Chip(
                label: Text(category.name),
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: const Color(0xFF475467),
                  fontSize: 12,
                ),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onTap});

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .06),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: product.image != null && product.image!.isNotEmpty
                    ? Image.network(
                        product.image!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.shopping_bag_outlined, size: 42),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.shopping_bag_outlined, size: 42),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${product.price.toStringAsFixed(0)} EGP',
                    style: const TextStyle(
                      color: Color(0xFFFF6900),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
