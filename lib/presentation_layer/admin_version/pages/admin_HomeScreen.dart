import 'package:buy_verse_app/presentation_layer/admin_version/pages/notifications/notifications_page.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/orders/order_details.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/orders/orders_page.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/category/manage_category.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/products/add_product.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/products/product_details.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/products/products_show.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/profile/profile_page.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/category/category_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/layout/layout_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/notification/notification_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/profile/profile_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../data_layer/admin/admin_models/order.dart' as order_models;
import '../../../../data_layer/admin/admin_models/product.dart'
    as product_models;
import '../../../core_layer/admin/helpers/app_localization.dart';
import '../state_management/order/order_bloc.dart';
import '../state_management/product/product_bloc.dart';
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
    var l10n = AppLocalizations.of(context);
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
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                label: l10n?.translate('home') ?? 'Home',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.inventory_2_outlined),
                label: l10n?.translate('products') ?? 'Products',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.shopping_bag_outlined),
                label: l10n?.translate('orders') ?? 'Orders',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                label: l10n?.translate('profile') ?? 'Profile',
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
    var l10n = AppLocalizations.of(context);
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, productState) {
        return BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, categoryState) {
            return BlocBuilder<OrderBloc, OrderState>(
              builder: (context, orderState) {
                return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, profileState) {
                    String totalProducts = '0';
                    String totalCategories = '0';
                    String totalOrders = '0';
                    String pendingOrders = '0';
                    List<product_models.Product> recentProducts = [];
                    List<order_models.Order> recentOrdersList = [];

                    if (productState is ProductLoaded) {
                      totalProducts = productState.products.length.toString();
                      recentProducts = productState.products.reversed
                          .take(3)
                          .toList();
                    }

                    if (categoryState is CategoryLoaded) {
                      totalCategories = categoryState.categories.length
                          .toString();
                    }

                    if (orderState is OrderLoaded) {
                      totalOrders = orderState.orders.length.toString();
                      pendingOrders = orderState.orders
                          .where((o) => o.status == 'Pending')
                          .length
                          .toString();
                      recentOrdersList = orderState.orders.reversed
                          .take(2)
                          .toList();
                    }

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context, profileState),
                          Padding(
                            padding: EdgeInsets.all(context.setWidth(20.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _buildStatCard(
                                      context,
                                      icon: Icons.inventory_2_outlined,
                                      value: totalProducts,
                                      label:
                                          l10n?.translate('total_products') ??
                                          'Total Products',
                                      color: Colors.orange,
                                      bgColor: const Color(0xFFFFF7F0),
                                      onTap: () => navigateTo(
                                        context,
                                        const ProductsShowPage(),
                                      ),
                                    ),
                                    Gap(context.setWidth(15)),
                                    _buildStatCard(
                                      context,
                                      icon: Icons.shopping_bag_outlined,
                                      value: totalOrders,
                                      label:
                                          l10n?.translate('total_orders') ??
                                          'Total Orders',
                                      color: Colors.blue,
                                      bgColor: const Color(0xFFF0F7FF),
                                      onTap: () => navigateTo(
                                        context,
                                        const OrdersPage(),
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(context.setWidth(15)),
                                Row(
                                  children: [
                                    _buildStatCard(
                                      context,
                                      icon: Icons.access_time,
                                      value: pendingOrders,
                                      label:
                                          l10n?.translate('pending_orders') ??
                                          'Pending Orders',
                                      color: Colors.brown,
                                      bgColor: const Color(0xFFFFFBF0),
                                      onTap: () => navigateTo(
                                        context,
                                        const OrdersPage(showPendingOnly: true),
                                      ),
                                    ),
                                    Gap(context.setWidth(15)),
                                    _buildStatCard(
                                      context,
                                      icon: Icons.local_offer_outlined,
                                      value: totalCategories,
                                      label:
                                          l10n?.translate('categories') ??
                                          'Categories',
                                      color: Colors.teal,
                                      bgColor: const Color(0xFFF0FFF7),
                                      onTap: () => navigateTo(
                                        context,
                                        const ManageCategoryPage(),
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(context.setHeight(30)),
                                Text(
                                  l10n?.translate('quick_actions') ??
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
                                        function: () {
                                          if (categoryState is CategoryLoaded &&
                                              categoryState
                                                  .categories
                                                  .isEmpty) {
                                            showToast(
                                              context: context,
                                              text:
                                                  l10n?.translate(
                                                    'create_category_first',
                                                  ) ??
                                                  'Please create a category first',
                                              state: ToastStates.WARNING,
                                            );
                                          } else {
                                            navigateTo(
                                              context,
                                              const AddProductPage(),
                                            );
                                          }
                                        },
                                        text:
                                            l10n?.translate('add_product') ??
                                            'Add Product',
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
                                            color: HexColor(
                                              'F5821F',
                                            ).withValues(alpha: 0.2),
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () => navigateTo(
                                            context,
                                            const ManageCategoryPage(),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.local_offer_outlined,
                                                color: HexColor('F5821F'),
                                                size: context.setWidth(20),
                                              ),
                                              Gap(context.setWidth(8)),
                                              Text(
                                                l10n?.translate('categories') ??
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
                                _buildSectionHeader(
                                  l10n?.translate('recent_orders') ??
                                      'Recent Orders',
                                  context,
                                  onTap: () =>
                                      navigateTo(context, const OrdersPage()),
                                ),
                                Gap(context.setHeight(15)),
                                if (orderState is OrderLoading)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else if (recentOrdersList.isEmpty)
                                  Center(
                                    child: Text(
                                      l10n?.translate('no_orders') ??
                                          'No orders yet',
                                    ),
                                  )
                                else
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        _buildOrderItem(
                                          context,
                                          orderId:
                                              '#${recentOrdersList[index].id.length > 8 ? recentOrdersList[index].id.substring(0, 8).toUpperCase() : recentOrdersList[index].id.toUpperCase()}',
                                          customer:
                                              recentOrdersList[index].customer,
                                          price: recentOrdersList[index].price,
                                          status:
                                              recentOrdersList[index].status,
                                          statusColor:
                                              recentOrdersList[index].status ==
                                                  'Pending'
                                              ? Colors.orange
                                              : Colors.green,
                                          onTap: () => navigateTo(
                                            context,
                                            const OrderDetailsPage(),
                                          ),
                                        ),
                                    separatorBuilder: (context, index) =>
                                        Gap(context.setHeight(12)),
                                    itemCount: recentOrdersList.length,
                                  ),
                                Gap(context.setHeight(30)),
                                _buildSectionHeader(
                                  l10n?.translate('products_overview') ??
                                      'Products Overview',
                                  context,
                                  onTap: () => navigateTo(
                                    context,
                                    const ProductsShowPage(),
                                  ),
                                ),
                                Gap(context.setHeight(15)),
                                if (productState is ProductLoading)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else if (recentProducts.isEmpty)
                                  Center(
                                    child: Text(
                                      l10n?.translate('no_products') ??
                                          'No products added yet',
                                    ),
                                  )
                                else
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        _buildProductItem(
                                          context,
                                          name: recentProducts[index].name,
                                          details:
                                              '${recentProducts[index].price} - Qty ${recentProducts[index].quantity}',
                                          status:
                                              recentProducts[index].isVisible
                                              ? 'Visible'
                                              : 'Hidden',
                                          statusColor:
                                              recentProducts[index].isVisible
                                              ? Colors.green
                                              : Colors.grey,
                                          image: recentProducts[index].image,
                                          onTap: () => navigateTo(
                                            context,
                                            ProductDetailsPage(
                                              product: recentProducts[index],
                                            ),
                                          ),
                                        ),
                                    separatorBuilder: (context, index) =>
                                        Gap(context.setHeight(12)),
                                    itemCount: recentProducts.length,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ProfileState state) {
    String name = 'Ahmed Khalil';
    String businessName = 'Khalil Digital Store';
    String profileImage = '';

    if (state is ProfileLoaded) {
      name = state.profile.fullName;
      businessName = state.profile.businessName;
      profileImage = state.profile.profileImage;
    }

    return InkWell(
      onTap: () {
        context.read<LayoutBloc>().add(ChangeBottomNavIndex(3));
      },
      child: Container(
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
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              backgroundImage: profileImage.isNotEmpty
                  ? CachedNetworkImageProvider(profileImage) as ImageProvider
                  : const AssetImage('assets/images/businessman.png')
                        as ImageProvider,
              onBackgroundImageError: (exception, stackTrace) {
                print('Error loading profile image: $exception');
              },
            ),
            Gap(context.setWidth(15)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.translate('good_morning') ??
                        'Good morning,',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: context.setSp(14),
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.setSp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    businessName,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: context.setSp(12),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(context.setWidth(4)),
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  int count = 0;
                  if (state is NotificationLoaded) {
                    count = state.unreadCount;
                  }
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      IconButton(
                        onPressed: () =>
                            navigateTo(context, const NotificationsPage()),
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      if (count > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: HexColor('F5821F'),
                                width: 1.5,
                              ),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
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

  Widget _buildSectionHeader(
    String title,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
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
        InkWell(
          onTap: onTap,
          child: Text(
            AppLocalizations.of(context)?.translate('see_all') ?? 'See all',
            style: TextStyle(
              color: HexColor('F5821F'),
              fontSize: context.setSp(14),
              fontWeight: FontWeight.bold,
            ),
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
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
                  '$price EGP',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: context.setSp(16),
                  ),
                ),
              ],
            ),
          ],
        ),
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
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
              child: image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: image,
                      width: context.setWidth(50),
                      height: context.setHeight(50),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: context.setWidth(50),
                        height: context.setHeight(50),
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        print('Error loading product image: $error');
                        return Container(
                          width: context.setWidth(50),
                          height: context.setHeight(50),
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    )
                  : Container(
                      width: context.setWidth(50),
                      height: context.setHeight(50),
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
      ),
    );
  }
}
