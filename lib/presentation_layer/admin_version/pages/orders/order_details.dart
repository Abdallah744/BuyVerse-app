// ignore_for_file: dead_code, unnecessary_null_comparison, unused_local_variable

import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core_layer/admin/helpers/app_localization.dart';
import '../../../../data_layer/admin/admin_models/order.dart' as order_models;
import '../../state_management/order/order_bloc.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, this.order});

  final order_models.Order? order;

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: HexColor('F7F8FA'),
      appBar: defaultAppBar(
        context: context,
        title: l10n?.translate('order_details') ?? 'Order Details',
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          final currentOrder = order;
          if (currentOrder == null) {
            return Center(
              child: Text(
                l10n?.translate('no_order_data') ?? 'No order data available',
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(context.setWidth(20.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(context, currentOrder),
                  Gap(context.setHeight(20)),
                  _buildSectionTitle(
                    l10n?.translate('customer') ?? 'CUSTOMER',
                    context,
                  ),
                  Gap(context.setHeight(10)),
                  _buildCustomerSection(context, currentOrder),
                  Gap(context.setHeight(20)),
                  _buildSectionTitle(
                    l10n?.translate('delivery') ?? 'DELIVERY',
                    context,
                  ),
                  Gap(context.setHeight(10)),
                  _buildDeliverySection(context, currentOrder),
                  Gap(context.setHeight(20)),
                  _buildSectionTitle(
                    l10n?.translate('items') ?? 'ORDER ITEMS',
                    context,
                  ),
                  Gap(context.setHeight(10)),
                  _buildOrderItemsSection(context, currentOrder),
                  Gap(context.setHeight(20)),
                  _buildSectionTitle(
                    l10n?.translate('payment_method') ?? 'PAYMENT',
                    context,
                  ),
                  Gap(context.setHeight(10)),
                  _buildPaymentSection(context, currentOrder),
                  Gap(context.setHeight(20)),
                  _buildSectionTitle(
                    l10n?.translate('summary') ?? 'SUMMARY',
                    context,
                  ),
                  Gap(context.setHeight(10)),
                  _buildSummarySection(context, currentOrder),
                  Gap(context.setHeight(20)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: context.setSp(12),
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, order_models.Order order) {
    var l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.all(context.setWidth(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.setWidth(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${order.id}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: context.setSp(18),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.setWidth(10),
                  vertical: context.setHeight(4),
                ),
                decoration: BoxDecoration(
                  color: order.statusColor == 'green'
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(context.setWidth(20)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: context.setWidth(6),
                      height: context.setWidth(6),
                      decoration: BoxDecoration(
                        color: order.statusColor == 'green'
                            ? Colors.green
                            : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(context.setWidth(6)),
                    Text(
                      order.status,
                      style: TextStyle(
                        color: order.statusColor == 'green'
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(context.setHeight(5)),
          Row(
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
                  fontSize: context.setSp(13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection(BuildContext context, order_models.Order order) {
    return Container(
      padding: EdgeInsets.all(context.setWidth(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.setWidth(20)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: context.setWidth(20),
                backgroundColor: HexColor('F5821F'),
                child: Text(
                  order.customer.isNotEmpty
                      ? order.customer[0].toUpperCase()
                      : 'C',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: context.setSp(14),
                  ),
                ),
              ),
              Gap(context.setWidth(15)),
              Expanded(
                child: Text(
                  order.customer,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.setSp(16),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySection(BuildContext context, order_models.Order order) {
    var l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.all(context.setWidth(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.setWidth(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.grey[400],
                size: 20,
              ),
              Gap(context.setWidth(10)),
              Expanded(
                child: Text(
                  order.items, // Using items field as delivery info for now
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsSection(
    BuildContext context,
    order_models.Order order,
  ) {
    return Container(
      padding: EdgeInsets.all(context.setWidth(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.setWidth(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.items,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: context.setSp(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context, order_models.Order order) {
    return Container(
      padding: EdgeInsets.all(context.setWidth(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.setWidth(20)),
      ),
      child: Row(
        children: [
          Icon(Icons.payments_outlined, color: Colors.grey[400], size: 20),
          Gap(context.setWidth(10)),
          Text(
            order.payment,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: context.setSp(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, order_models.Order order) {
    var l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.all(context.setWidth(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.setWidth(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n?.translate('total_price') ?? 'Total',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: context.setSp(14),
            ),
          ),
          Text(
            order.price,
            style: TextStyle(
              color: HexColor('F5821F'),
              fontWeight: FontWeight.w900,
              fontSize: context.setSp(22),
            ),
          ),
        ],
      ),
    );
  }
}
