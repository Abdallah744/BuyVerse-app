// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/user/user_models/category_model.dart';
import '../../../data_layer/user/user_models/product_model.dart';
import '../state_management/auth/auth_cubit.dart';
import '../state_management/category_cubit.dart';
import '../state_management/profile/profile_cubit.dart';
import '../state_management/proudcts/product_cubit.dart';
import '../widgets/shop_bottom_navigation.dart';
import 'product_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.authToken, this.compact = false});

  final String? authToken;
  final bool compact;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts(token: widget.authToken);
    context.read<CategoryCubit>().fetchCategories(token: widget.authToken);
    context.read<UserProfileCubit>().fetchProfile(token: widget.authToken);
  }

  @override
  Widget build(BuildContext context) {
    return _HomeView(authToken: widget.authToken, compact: widget.compact);
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView({required this.authToken, required this.compact});

  final String? authToken;
  final bool compact;

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _Header(compact: widget.compact, authToken: widget.authToken),
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
            BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, categoryState) {
                final categories = categoryState is CategoryLoaded
                    ? categoryState.categories
                    : const <CategoryModel>[];
                
                // If categories exist, show filter chips
                if (categories.isNotEmpty) {
                  return SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _FilterChip(
                                label: 'All',
                                isSelected: _selectedCategoryId == null,
                                onTap: () {
                                  setState(() {
                                    _selectedCategoryId = null;
                                  });
                                  context.read<ProductCubit>().fetchProducts(token: widget.authToken);
                                },
                              ),
                              ...categories.map((category) => _FilterChip(
                                label: category.name,
                                isSelected: _selectedCategoryId == category.id,
                                onTap: () {
                                  setState(() {
                                    _selectedCategoryId = category.id;
                                  });
                                  // Filter products by category
                                  context.read<ProductCubit>().fetchProducts(
                                    token: widget.authToken,
                                    categoryId: category.id,
                                  );
                                },
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                }
                
                return const SliverToBoxAdapter();
              },
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
                              authToken: widget.authToken,
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

class _Header extends StatelessWidget {
  const _Header({required this.compact, this.authToken});

  final bool compact;
  final String? authToken;

  @override
  Widget build(BuildContext context) {
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
                    BlocBuilder<UserProfileCubit, UserProfileState>(
                      builder: (context, state) {
                        String name = 'User';
                        if (state is ProfileLoaded) {
                          name = state.user.name ?? 'User';
                        } else {
                          final authState = context.read<AuthCubit>().state;
                          if (authState is AuthSuccess) {
                            name = authState.user.name ?? 'User';
                          }
                        }
                        return Text(
                          name.trim().isEmpty ? 'User' : name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF101828),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 19,
                backgroundColor: Color(0xFFFF6900),
                child: Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF98A2B3)),
              filled: true,
              fillColor: Colors.white,
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
                child:
                    product.image != null &&
                        (product.image?.isNotEmpty ?? false)
                    ? Image.network(
                        product.image ?? '',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Center(
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xFFFF6900),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF475467),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFE5E7EB)),
    );
  }
}
