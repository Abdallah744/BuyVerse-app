import 'package:buy_verse_app/core_layer/admin/helpers/app_localization.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/category/manage_category.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/products/add_product.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/products/product_details.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/category/category_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/product/product_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../data_layer/admin/admin_models/product.dart';

class ProductsShowPage extends StatefulWidget {
  const ProductsShowPage({super.key});

  @override
  State<ProductsShowPage> createState() => _ProductsShowPageState();
}

class _ProductsShowPageState extends State<ProductsShowPage> {
  var searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: HexColor('F7F8FA'),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(left: context.setWidth(20)),
          child: Text(
            l10n?.translate('products') ?? 'Products',
            style: TextStyle(
              color: Colors.black,
              fontSize: context.setSp(24),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: context.setWidth(20)),
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, categoryState) {
                return InkWell(
                  onTap: () {
                    if (categoryState is CategoryLoaded &&
                        categoryState.categories.isEmpty) {
                      showToast(
                        context: context,
                        text:
                            l10n?.translate('create_category_first') ??
                            'Please create at least one category first',
                        state: ToastStates.WARNING,
                      );
                    } else {
                      navigateTo(context, const AddProductPage());
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(context.setWidth(8)),
                    decoration: BoxDecoration(
                      color: HexColor('F5821F'),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: context.setWidth(20),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            var filteredProducts = state.products
                .where(
                  (product) => product.name.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ),
                )
                .toList();

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: context.setWidth(20)),
              child: Column(
                children: [
                  Gap(context.setHeight(10)),
                  defaultTextFormField(
                    context: context,
                    controller: searchController,
                    type: TextInputType.text,
                    validate: (value) => null,
                    label:
                        l10n?.translate('search_products') ??
                        'Search products...',
                    suffix: Icons.search,
                    onChange: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                  Gap(context.setHeight(15)),
                  OutlinedButton(
                    onPressed: () =>
                        navigateTo(context, const ManageCategoryPage()),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: HexColor('F5821F')),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          context.setWidth(10),
                        ),
                      ),
                      minimumSize: Size(double.infinity, context.setHeight(50)),
                    ),
                    child: Text(
                      l10n?.translate('manage_categories') ??
                          'Manage Categories',
                      style: TextStyle(
                        color: HexColor('F5821F'),
                        fontWeight: FontWeight.bold,
                        fontSize: context.setSp(16),
                      ),
                    ),
                  ),
                  Gap(context.setHeight(20)),
                  if (filteredProducts.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          l10n?.translate('no_products') ??
                              'No products match your search',
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) =>
                            _buildProductItem(context, filteredProducts[index]),
                        separatorBuilder: (context, index) =>
                            Gap(context.setHeight(15)),
                        itemCount: filteredProducts.length,
                      ),
                    ),
                ],
              ),
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          }
          return Center(
            child: Text(l10n?.translate('no_products') ?? 'No products found'),
          );
        },
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, Product product) {
    var l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: () => navigateTo(context, ProductDetailsPage(product: product)),
      child: Container(
        padding: EdgeInsets.all(context.setWidth(12)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(context.setWidth(20)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(context.setWidth(12)),
              child: product.image.isNotEmpty && product.image != 'null'
                  ? CachedNetworkImage(
                      imageUrl: product.image,
                      width: context.setWidth(60),
                      height: context.setHeight(60),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: context.setWidth(60),
                        height: context.setHeight(60),
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: context.setWidth(60),
                        height: context.setHeight(60),
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    )
                  : Container(
                      width: context.setWidth(60),
                      height: context.setHeight(60),
                      color: Colors.grey[200],
                      child: const Icon(Icons.image),
                    ),
            ),
            Gap(context.setWidth(15)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: context.setSp(16),
                    ),
                  ),
                  Text(
                    product.category,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: context.setSp(14),
                    ),
                  ),
                  Gap(context.setHeight(4)),
                  Row(
                    children: [
                      Text(
                        '${product.price} EGP',
                        style: TextStyle(
                          color: HexColor('F5821F'),
                          fontWeight: FontWeight.bold,
                          fontSize: context.setSp(16),
                        ),
                      ),
                      Gap(context.setWidth(10)),
                      Text(
                        '${l10n?.translate('quantity') ?? 'Qty'} ${product.quantity}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: context.setSp(14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.setWidth(10),
                vertical: context.setHeight(6),
              ),
              decoration: BoxDecoration(
                color: (product.isVisible ? Colors.green : Colors.grey)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(context.setWidth(20)),
              ),
              child: Row(
                children: [
                  Container(
                    width: context.setWidth(6),
                    height: context.setWidth(6),
                    decoration: BoxDecoration(
                      color: product.isVisible ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Gap(context.setWidth(6)),
                  Text(
                    product.isVisible
                        ? l10n?.translate('visible') ?? 'Visible'
                        : l10n?.translate('hidden') ?? 'Hidden',
                    style: TextStyle(
                      color: product.isVisible ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: context.setSp(12),
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
