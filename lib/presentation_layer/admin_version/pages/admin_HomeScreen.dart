import 'package:buy_verse_app/presentation_layer/admin_version/pages/orders/orders_page.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/category/manage_category.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/products/add_product.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/products/products_show.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/profile/profile_page.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/layout/layout_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

import '../widgets/responsive_helper.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  final List<Widget> _screens = const [
    _HomeContent(),
    ProductsShowPage(),
    OrdersPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutBloc, LayoutState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: HexColor('F7F8FA'),
          body: _screens[state.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) =>
                context.read<LayoutBloc>().add(ChangeBottomNavIndex(index)),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: HexColor('F5821F'),
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeader(context),

          Padding(
            padding: EdgeInsets.all(context.setWidth(20.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Grid
                Row(
                  children: [
                    _buildStatCard(
                      context,
                      icon: Icons.inventory_2_outlined,
                      value: '4',
                      label: 'Total Products',
                      color: Colors.orange,
                      bgColor: const Color(0xFFFFF7F0),
                      onTap: () =>
                          navigateTo(context, const ProductsShowPage()),
                    ),
                    Gap(context.setWidth(15)),
                    _buildStatCard(
                      context,
                      icon: Icons.shopping_bag_outlined,
                      value: '2',
                      label: 'Total Orders',
                      color: Colors.blue,
                      bgColor: const Color(0xFFF0F7FF),
                    ),
                  ],
                ),
                Gap(context.setWidth(15)),
                Row(
                  children: [
                    _buildStatCard(
                      context,
                      icon: Icons.access_time,
                      value: '2',
                      label: 'Pending Orders',
                      color: Colors.brown,
                      bgColor: const Color(0xFFFFFBF0),
                    ),
                    Gap(context.setWidth(15)),
                    _buildStatCard(
                      context,
                      icon: Icons.local_offer_outlined,
                      value: '3',
                      label: 'Categories',
                      color: Colors.teal,
                      bgColor: const Color(0xFFF0FFF7),
                      onTap: () =>
                          navigateTo(context, const ManageCategoryPage()),
                    ),
                  ],
                ),

                Gap(context.setHeight(30)),
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: context.setSp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(context.setWidth(15)),
                Row(
                  children: [
                    Expanded(
                      child: defaultButton(
                        context: context,
                        function: () =>
                            navigateTo(context, const AddProductPage()),
                        text: 'Add Product',
                        background: HexColor('F5821F'),
                        radius: 15,
                        height: context.setHeight(55),
                      ),
                    ),
                    Gap(context.setWidth(15)),
                    Expanded(
                      child: Container(
                        height: context.setHeight(55),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7F0),
                          borderRadius: BorderRadius.circular(
                            context.setWidth(15),
                          ),
                          border: Border.all(
                            color: HexColor('F5821F').withValues(alpha: 0.2),
                          ),
                        ),
                        child: InkWell(
                          onTap: () =>
                              navigateTo(context, const ManageCategoryPage()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_offer_outlined,
                                color: HexColor('F5821F'),
                                size: context.setWidth(20),
                              ),
                              Gap(context.setWidth(8)),
                              Text(
                                'Categories',
                                style: TextStyle(
                                  color: HexColor('F5821F'),
                                  fontWeight: FontWeight.bold,
                                  fontSize: context.setSp(16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Gap(context.setHeight(30)),
                _buildSectionHeader('Recent Orders', context),
                Gap(context.setHeight(15)),
                _buildOrderItem(
                  context,
                  orderId: '#567ITDSD',
                  customer: 'Sarah Mitchell',
                  price: '687',
                  status: 'Pending',
                  statusColor: Colors.orange,
                ),
                Gap(context.setHeight(12)),
                _buildOrderItem(
                  context,
                  orderId: '#891KLFPR',
                  customer: 'Omar Hassan',
                  price: '599',
                  status: 'Pending',
                  statusColor: Colors.orange,
                ),

                Gap(context.setHeight(30)),
                _buildSectionHeader('Products Overview', context),
                Gap(context.setHeight(15)),
                _buildProductItem(
                  context,
                  name: 'Wireless Headphones',
                  details: '299 - Qty 45',
                  status: 'Visible',
                  statusColor: Colors.green,
                  image:
                      'https://img.freepik.com/free-photo/shiny-black-headphones-reflect-golden-luxury-generated-by-ai_188544-23030.jpg',
                ),
                Gap(context.setHeight(12)),
                _buildProductItem(
                  context,
                  name: 'Cotton T-Shirt',
                  details: '89 - Qty 120',
                  status: 'Visible',
                  statusColor: Colors.green,
                  image:
                      'https://img.freepik.com/free-photo/simple-white-t-shirt-men-s-apparel_53876-102021.jpg',
                ),
                Gap(context.setHeight(12)),
                _buildProductItem(
                  context,
                  name: 'Organic Coffee',
                  details: '45 - Qty 200',
                  status: 'Hidden',
                  statusColor: Colors.grey,
                  image:
                      'https://img.freepik.com/free-photo/coffee-beans-bag_23-2148270542.jpg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        context.setWidth(20),
        context.topPadding + context.setHeight(20),
        context.setWidth(20),
        context.setHeight(40),
      ),
      decoration: BoxDecoration(
        color: HexColor('F5821F'),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(context.setWidth(30)),
          bottomRight: Radius.circular(context.setWidth(30)),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: context.setWidth(28),
            backgroundImage: const AssetImage('assets/images/businessman.png'),
          ),
          Gap(context.setWidth(15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning,',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: context.setSp(14),
                  ),
                ),
                Text(
                  'Ahmed Khalil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.setSp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Khalil Digital Store',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: context.setSp(12),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(context.setWidth(8)),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: context.setWidth(24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required Color bgColor,
    Function()? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(context.setWidth(15)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.setWidth(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: context.setWidth(10),
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(context.setWidth(8)),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(context.setWidth(10)),
                ),
                child: Icon(icon, color: color, size: context.setWidth(20)),
              ),
              Gap(context.setHeight(12)),
              Text(
                value,
                style: TextStyle(
                  fontSize: context.setSp(22),
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: context.setSp(13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: context.setSp(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'See all',
          style: TextStyle(
            color: HexColor('F5821F'),
            fontSize: context.setSp(14),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(
    BuildContext context, {
    required String orderId,
    required String customer,
    required String price,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: EdgeInsets.all(context.setWidth(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.setWidth(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(context.setWidth(10)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7F0),
              borderRadius: BorderRadius.circular(context.setWidth(12)),
            ),
            child: Icon(
              Icons.shopping_basket_outlined,
              color: HexColor('F5821F'),
              size: context.setWidth(24),
            ),
          ),
          Gap(context.setWidth(15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderId,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.setSp(16),
                  ),
                ),
                Text(
                  customer,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: context.setSp(14),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    width: context.setWidth(8),
                    height: context.setWidth(8),
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Gap(context.setWidth(6)),
                  Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: context.setSp(14),
                    ),
                  ),
                ],
              ),
              Gap(context.setHeight(4)),
              Text(
                price,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: context.setSp(16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(
    BuildContext context, {
    required String name,
    required String details,
    required String status,
    required Color statusColor,
    required String image,
  }) {
    return Container(
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
              image,
              width: context.setWidth(50),
              height: context.setHeight(50),
              fit: BoxFit.cover,
            ),
          ),
          Gap(context.setWidth(15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.setSp(16),
                  ),
                ),
                Text(
                  details,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: context.setSp(14),
                  ),
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
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(context.setWidth(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: context.setWidth(6),
                  height: context.setWidth(6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Gap(context.setWidth(6)),
                Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: context.setSp(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
