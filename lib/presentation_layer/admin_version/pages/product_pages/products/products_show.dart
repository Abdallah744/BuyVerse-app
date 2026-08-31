import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/category/manage_category.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/products/add_product.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/products/product_details.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/admin_models/admin_models.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/product/product_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

class ProductsShowPage extends StatelessWidget {
  const ProductsShowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('F7F8FA'),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(left: context.setWidth(20)),
          child: Text(
            'Products',
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
            child: InkWell(
              onTap: () => navigateTo(context, const AddProductPage()),
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
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: context.setWidth(20)),
              child: Column(
                children: [
                  Gap(context.setHeight(10)),
                  defaultTextFormField(
                    context: context,
                    controller: TextEditingController(),
                    type: TextInputType.text,
                    validate: (value) => null,
                    label: 'Search products...',
                    suffix: Icons.search,
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
                      'Manage Categories',
                      style: TextStyle(
                        color: HexColor('F5821F'),
                        fontWeight: FontWeight.bold,
                        fontSize: context.setSp(16),
                      ),
                    ),
                  ),
                  Gap(context.setHeight(20)),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) =>
                          _buildProductItem(context, state.products[index]),
                      separatorBuilder: (context, index) =>
                          Gap(context.setHeight(15)),
                      itemCount: state.products.length,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No products found'));
        },
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, Product product) {
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
              child: Image.network(
                product.image,
                width: context.setWidth(60),
                height: context.setHeight(60),
                fit: BoxFit.cover,
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
                        product.price,
                        style: TextStyle(
                          color: HexColor('F5821F'),
                          fontWeight: FontWeight.bold,
                          fontSize: context.setSp(16),
                        ),
                      ),
                      Gap(context.setWidth(10)),
                      Text(
                        'Qty ${product.quantity}',
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
                    product.isVisible ? 'Visible' : 'Hidden',
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
