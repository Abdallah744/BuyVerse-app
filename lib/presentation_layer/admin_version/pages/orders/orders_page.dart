// ignore_for_file: unused_local_variable

import 'package:buy_verse_app/presentation_layer/admin_version/pages/orders/order_details.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/order/order_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core_layer/admin/helpers/app_localization.dart';
import '../../../../data_layer/admin/admin_models/order.dart';

class OrdersPage extends StatelessWidget {
  final bool showPendingOnly;

  const OrdersPage({super.key, this.showPendingOnly = false});

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: HexColor('F7F8FA'),
      appBar: showPendingOnly
          ? defaultAppBar(
              context: context,
              title: l10n?.translate('pending_orders') ?? 'Pending Orders',
            )
          : null,
      body: SafeArea(
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrderLoaded) {
              var orders = state.orders;
              if (showPendingOnly) {
                orders = orders
                    .where((order) => order.status == 'Pending')
                    .toList();
              }

              if (orders.isEmpty) {
                return Center(
                  child: Text(
                    l10n?.translate('no_orders') ?? 'No orders found',
                  ),
                );
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(context.setWidth(20.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!showPendingOnly)
                        Text(
                          l10n?.translate('orders') ?? 'Orders',
                          style: TextStyle(
                            fontSize: context.setSp(28),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (!showPendingOnly) Gap(context.setHeight(20)),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) =>
                            _buildOrderItem(context, order: orders[index]),
                        separatorBuilder: (context, index) =>
                            Gap(context.setHeight(15)),
                        itemCount: orders.length,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Center(
              child: Text(l10n?.translate('error') ?? 'Something went wrong'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, {required Order order}) {
    var l10n = AppLocalizations.of(context);
    Color statusColor = order.status == 'Delivered'
        ? Colors.green
        : Colors.orange;

    return InkWell(
      onTap: () {
        navigateTo(context, OrderDetailsPage(order: order));
      },
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${order.id.length > 8 ? order.id.substring(0, 8).toUpperCase() : order.id.toUpperCase()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.setSp(16),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.setWidth(10),
                    vertical: context.setHeight(4),
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
                        order.status,
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
            Gap(context.setHeight(5)),
            Text(
              order.customer,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: context.setSp(14),
              ),
            ),
            Gap(context.setHeight(10)),
            Wrap(
              spacing: context.setWidth(10),
              runSpacing: context.setHeight(5),
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: context.setWidth(14),
                      color: Colors.grey,
                    ),
                    Gap(context.setWidth(5)),
                    Text(
                      order.date,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: context.setSp(12),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: context.setWidth(14),
                      color: Colors.grey,
                    ),
                    Gap(context.setWidth(5)),
                    Text(
                      order.items,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: context.setSp(12),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.payment_outlined,
                      size: context.setWidth(14),
                      color: Colors.grey,
                    ),
                    Gap(context.setWidth(5)),
                    Text(
                      order.payment,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: context.setSp(12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Gap(context.setHeight(15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.price} EGP',
                  style: TextStyle(
                    color: HexColor('F5821F'),
                    fontWeight: FontWeight.w900,
                    fontSize: context.setSp(18),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: context.setWidth(16),
                  color: Colors.grey[400],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
