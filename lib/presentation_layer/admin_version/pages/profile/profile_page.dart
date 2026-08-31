import 'package:buy_verse_app/presentation_layer/admin_version/pages/profile/edit_profile.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('F7F8FA'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: EdgeInsets.all(context.setWidth(20.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    context,
                    title: 'PERSONAL INFORMATION',
                    items: [
                      _buildInfoItem(
                        context,
                        icon: Icons.person_outline,
                        label: 'Full Name',
                        value: 'Ahmed Khalil',
                      ),
                      _buildInfoItem(
                        context,
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: 'ahmed@khalilstore.com',
                      ),
                      _buildInfoItem(
                        context,
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: '+20 100 123 4567',
                      ),
                      _buildInfoItem(
                        context,
                        icon: Icons.badge_outlined,
                        label: 'National ID',
                        value: '29801234567890',
                      ),
                    ],
                  ),
                  Gap(context.setHeight(20)),
                  _buildSection(
                    context,
                    title: 'BUSINESS INFORMATION',
                    items: [
                      _buildInfoItem(
                        context,
                        icon: Icons.storefront_outlined,
                        label: 'Business Name',
                        value: 'Khalil Digital Store',
                      ),
                      _buildInfoItem(
                        context,
                        icon: Icons.location_on_outlined,
                        label: 'Business Address',
                        value: '18 El Nasr Road, Nasr City, Cairo',
                      ),
                      _buildInfoItem(
                        context,
                        icon: Icons.map_outlined,
                        label: 'Store Location',
                        value: 'Cairo, Egypt',
                      ),
                    ],
                  ),
                  Gap(context.setHeight(20)),
                  _buildSection(
                    context,
                    title: 'BUSINESS DOCUMENTS',
                    items: [
                      _buildDocumentItem(
                        context,
                        label: 'Commercial Register',
                        isUploaded: true,
                      ),
                      _buildDocumentItem(
                        context,
                        label: 'Tax Card',
                        isUploaded: false,
                      ),
                    ],
                  ),
                  Gap(context.setHeight(30)),
                  defaultButton(
                    context: context,
                    function: () {
                      navigateTo(context, const EditProfilePage());
                    },
                    text: 'Edit Profile',
                    background: HexColor('F5821F'),
                    radius: 20,
                  ),
                  Gap(context.setHeight(20)),
                ],
              ),
            ),
          ],
        ),
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
      child: Column(
        children: [
          CircleAvatar(
            radius: context.setWidth(50),
            backgroundImage: const AssetImage('assets/images/businessman.png'),
          ),
          Gap(context.setWidth(15)),
          Text(
            'Ahmed Khalil',
            style: TextStyle(
              color: Colors.white,
              fontSize: context.setSp(22),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '@khalildigitalstore',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: context.setSp(14),
            ),
          ),
          Gap(context.setWidth(15)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.setWidth(15),
              vertical: context.setHeight(5),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(context.setWidth(20)),
            ),
            child: Text(
              'MERCHANT',
              style: TextStyle(
                color: Colors.white,
                fontSize: context.setSp(12),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: context.setSp(12),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        Gap(context.setHeight(10)),
        Container(
          padding: EdgeInsets.all(context.setWidth(15)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.setWidth(20)),
          ),
          child: Column(
            children: items.map((item) {
              int index = items.indexOf(item);
              return Column(
                children: [
                  item,
                  if (index != items.length - 1)
                    Divider(
                      color: Colors.grey[100],
                      height: context.setHeight(20),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[400], size: context.setWidth(20)),
        Gap(context.setWidth(10)),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: context.setSp(14),
          ),
        ),
        const Spacer(),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: context.setSp(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentItem(
    BuildContext context, {
    required String label,
    required bool isUploaded,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: context.setSp(14),
          ),
        ),
        const Spacer(),
        if (isUploaded)
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: context.setWidth(16),
              ),
              Gap(context.setWidth(5)),
              Text(
                'Uploaded',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: context.setSp(12),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.grey[400],
                size: context.setWidth(16),
              ),
              Gap(context.setWidth(5)),
              Text(
                'Not uploaded',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: context.setSp(12),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
