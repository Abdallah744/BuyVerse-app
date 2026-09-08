import 'package:buy_verse_app/core_layer/admin/helpers/app_localization.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/products/edit_product.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/product/product_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../data_layer/admin/admin_models/product.dart' as models;

class ProductDetailsPage extends StatelessWidget {
  final models.Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: HexColor('F7F8FA'),
      appBar: defaultAppBar(
        context: context,
        title: l10n?.translate('product_details') ?? 'Product Details',
        actions: [
          IconButton(
            onPressed: () =>
                navigateTo(context, EditProductPage(product: product)),
            icon: Icon(
              Icons.edit_outlined,
              color: Colors.black,
              size: context.setWidth(24),
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<ProductBloc>().add(DeleteProduct(product.id));
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: product.image,
              width: double.infinity,
              height: context.setHeight(300),
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: double.infinity,
                height: context.setHeight(300),
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                width: double.infinity,
                height: context.setHeight(300),
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, size: 50),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(context.setWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: context.setSp(24),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    product.category,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Gap(context.setHeight(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(
                        context,
                        l10n?.translate('price') ?? 'Price',
                        '${product.price} EGP',
                        HexColor('F5821F'),
                      ),
                      _buildStatItem(
                        context,
                        l10n?.translate('quantity') ?? 'In Stock',
                        product.quantity,
                        Colors.black,
                      ),
                      _buildStatusBadge(
                        context,
                        product.isVisible
                            ? l10n?.translate('visible') ?? 'Visible'
                            : l10n?.translate('hidden') ?? 'Hidden',
                        product.isVisible ? Colors.green : Colors.grey,
                      ),
                    ],
                  ),
                  Gap(context.setHeight(30)),
                  Text(
                    l10n?.translate('description') ?? 'DESCRIPTION',
                    style: TextStyle(
                      fontSize: context.setSp(14),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Gap(context.setHeight(10)),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: context.setSp(16), height: 1.5),
                  ),
                  Gap(context.setHeight(30)),
                  Text(
                    l10n?.translate('details') ?? 'DETAILS',
                    style: TextStyle(
                      fontSize: context.setSp(14),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Gap(context.setHeight(10)),
                  _buildDetailRow(
                    context,
                    l10n?.translate('category') ?? 'Category',
                    product.category,
                  ),
                  _buildDetailRow(
                    context,
                    l10n?.translate('added_date') ?? 'Added Date',
                    'Oct 24, 2023',
                  ),
                  Gap(context.setHeight(40)),
                  defaultButton(
                    context: context,
                    function: () =>
                        navigateTo(context, EditProductPage(product: product)),
                    text: l10n?.translate('edit_product') ?? 'Edit Product',
                    background: HexColor('F5821F'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color valueColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: context.setSp(14)),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: context.setSp(18),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.setWidth(12),
        vertical: context.setHeight(6),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(context.setWidth(20)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: context.setSp(14),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.setHeight(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: context.setSp(16),
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: context.setSp(16),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
