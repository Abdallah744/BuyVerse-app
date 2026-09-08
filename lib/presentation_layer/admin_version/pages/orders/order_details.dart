import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core_layer/admin/helpers/app_localization.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: HexColor('F7F8FA'),
      appBar: defaultAppBar(
        context: context,
        title: l10n?.translate('order_details') ?? 'Order Details',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.setWidth(20.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(context),
              Gap(context.setHeight(20)),
              _buildSectionTitle(
                l10n?.translate('customer') ?? 'CUSTOMER',
                context,
              ),
              Gap(context.setHeight(10)),
              _buildCustomerSection(context),
              Gap(context.setHeight(20)),
              _buildSectionTitle(
                l10n?.translate('delivery') ?? 'DELIVERY',
                context,
              ),
              Gap(context.setHeight(10)),
              _buildDeliverySection(context),
              Gap(context.setHeight(20)),
              _buildSectionTitle(
                l10n?.translate('items') ?? 'ORDER ITEMS',
                context,
              ),
              Gap(context.setHeight(10)),
              _buildOrderItemsSection(context),
              Gap(context.setHeight(20)),
              _buildSectionTitle(
                l10n?.translate('payment_method') ?? 'PAYMENT',
                context,
              ),
              Gap(context.setHeight(10)),
              _buildPaymentSection(context),
              Gap(context.setHeight(20)),
              _buildSectionTitle(
                l10n?.translate('summary') ?? 'SUMMARY',
                context,
              ),
              Gap(context.setHeight(10)),
              _buildSummarySection(context),
              Gap(context.setHeight(20)),
            ],
          ),
        ),
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

  Widget _buildHeaderSection(BuildContext context) {
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
                '#891KLFPR',
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
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(context.setWidth(20)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: context.setWidth(6),
                      height: context.setWidth(6),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(context.setWidth(6)),
                    Text(
                      l10n?.translate('pending') ?? 'Pending',
                      style: const TextStyle(
                        color: Colors.orange,
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
                'Jan 14, 2024 at 09:15 AM',
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

  Widget _buildCustomerSection(BuildContext context) {
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
                  'OH',
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
                  'Omar Hassan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.setSp(16),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Gap(context.setHeight(15)),
          Row(
            children: [
              Icon(Icons.email_outlined, color: Colors.grey[400], size: 18),
              Gap(context.setWidth(10)),
              const Text(
                'omar.hassan@email.com',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          Gap(context.setHeight(10)),
          Row(
            children: [
              Icon(Icons.phone_outlined, color: Colors.grey[400], size: 18),
              Gap(context.setWidth(10)),
              const Text(
                '+20 101 876 5432',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySection(BuildContext context) {
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
              const Expanded(
                child: Text(
                  '45 El Tahrir Square, Cairo, Egypt',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
          Gap(context.setHeight(10)),
          Row(
            children: [
              Icon(Icons.map_outlined, color: HexColor('F5821F'), size: 16),
              Gap(context.setWidth(5)),
              Text(
                l10n?.translate('view_on_map') ?? 'View on Map',
                style: TextStyle(
                  color: HexColor('F5821F'),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.setWidth(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.setWidth(20)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(context.setWidth(12)),
            child: Container(
              color: Colors.grey[100],
              width: context.setWidth(50),
              height: context.setWidth(50),
              child: Icon(
                Icons.watch_outlined,
                color: Colors.grey[400],
                size: 30,
              ),
            ),
          ),
          Gap(context.setWidth(15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Watch',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.setSp(15),
                  ),
                ),
                const Text(
                  'Electronics',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const Text(
                  '599 x 1',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            '599',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: context.setSp(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
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
            'Cash',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: context.setSp(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
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
            '599 EGP',
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
