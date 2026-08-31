import 'package:buy_verse_app/presentation_layer/admin_version/pages/orders/order_details.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('F7F8FA'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(context.setWidth(20.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Orders',
                  style: TextStyle(
                    fontSize: context.setSp(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(context.setHeight(20)),
                _buildOrderItem(
                  context,
                  orderId: '#567ITDSD',
                  customer: 'Sarah Mitchell',
                  date: 'Jan 15, 2024 - 02:32 PM',
                  items: '2 Items',
                  payment: 'Card',
                  price: '687',
                  status: 'Pending',
                ),
                Gap(context.setHeight(15)),
                _buildOrderItem(
                  context,
                  orderId: '#891KLFPR',
                  customer: 'Omar Hassan',
                  date: 'Jan 14, 2024 - 09:15 AM',
                  items: '1 Item',
                  payment: 'Cash',
                  price: '599',
                  status: 'Pending',
                ),
                Gap(context.setHeight(15)),
                _buildOrderItem(
                  context,
                  orderId: '#992PLXRT',
                  customer: 'John Doe',
                  date: 'Jan 13, 2024 - 11:45 AM',
                  items: '3 Items',
                  payment: 'Card',
                  price: '1,250',
                  status: 'Delivered',
                  statusColor: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem(
    BuildContext context, {
    required String orderId,
    required String customer,
    required String date,
    required String items,
    required String payment,
    required String price,
    required String status,
    Color statusColor = Colors.orange,
  }) {
    return InkWell(
      onTap: () {
        navigateTo(context, const OrderDetailsPage());
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
                  orderId,
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
            Gap(context.setHeight(5)),
            Text(
              customer,
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
                      date,
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
                      items,
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
                      payment,
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
                  price,
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
