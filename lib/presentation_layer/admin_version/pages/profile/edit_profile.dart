import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController(text: 'Ahmed Khalil');
  final emailController = TextEditingController(text: 'ahmed@khalilstore.com');
  final phoneController = TextEditingController(text: '+20 100 123 4567');
  final idController = TextEditingController(text: '29801234567890');
  final businessNameController = TextEditingController(
    text: 'Khalil Digital Store',
  );
  final businessAddressController = TextEditingController(
    text: '18 El Nasr Road, Nasr City, Cairo',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: defaultAppBar(context: context, title: 'Edit Profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.setWidth(20.0)),
          child: Column(
            children: [
              _buildAvatarSection(context),
              Gap(context.setWidth(30)),
              _buildFields(context),
              Gap(context.setWidth(30)),
              defaultButton(
                context: context,
                function: () {
                  Navigator.pop(context);
                },
                text: 'Save Changes',
                background: HexColor('F5821F'),
                radius: 20,
              ),
              Gap(context.setWidth(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: context.setWidth(50),
                backgroundImage: const AssetImage(
                  'assets/images/businessman.png',
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(context.setWidth(2)),
                child: CircleAvatar(
                  radius: context.setWidth(15),
                  backgroundColor: HexColor('F5821F'),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: context.setWidth(16),
                  ),
                ),
              ),
            ],
          ),
          Gap(context.setWidth(10)),
          TextButton(
            onPressed: () {},
            child: Text(
              'Change Photo',
              style: TextStyle(
                color: HexColor('F5821F'),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Full Name', context),
        defaultTextFormField(
          context: context,
          controller: nameController,
          type: TextInputType.name,
          validate: (value) {
            if (value!.isEmpty) return 'Name must not be empty';
            return null;
          },
          label: '',
          hint: 'Enter your full name',
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel('Email', context),
        emailTextFormField(
          context: context,
          controller: emailController,
          type: TextInputType.emailAddress,
          validate: (value) {
            if (value!.isEmpty) return 'Email must not be empty';
            return null;
          },
          label: '',
          hint: 'Enter your email',
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel('Phone', context),
        defaultTextFormField(
          context: context,
          controller: phoneController,
          type: TextInputType.phone,
          validate: (value) {
            if (value!.isEmpty) return 'Phone must not be empty';
            return null;
          },
          label: '',
          hint: 'Enter your phone number',
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel('National ID', context),
        defaultTextFormField(
          context: context,
          controller: idController,
          type: TextInputType.number,
          validate: (value) {
            if (value!.isEmpty) return 'ID must not be empty';
            return null;
          },
          label: '',
          hint: 'Enter your national ID',
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel('Business Name', context),
        defaultTextFormField(
          context: context,
          controller: businessNameController,
          type: TextInputType.text,
          validate: (value) {
            if (value!.isEmpty) return 'Business name must not be empty';
            return null;
          },
          label: '',
          hint: 'Enter your business name',
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel('Business Address (Optional)', context),
        defaultTextFormField(
          context: context,
          controller: businessAddressController,
          type: TextInputType.streetAddress,
          validate: (value) => null,
          label: '',
          hint: 'Enter your business address',
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel('Store Location (Optional)', context),
        _buildClickableField(
          context: context,
          icon: Icons.location_on_outlined,
          text: 'Cairo, Egypt - Tap to update',
          color: HexColor('F5821F').withValues(alpha: 0.1),
          textColor: HexColor('F5821F'),
          onTap: () {},
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel('Commercial Register (Optional)', context),
        _buildFileField(
          context: context,
          text: 'Commercial Register uploaded',
          isUploaded: true,
          onDelete: () {},
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel('Tax Card (Optional)', context),
        _buildFileField(
          context: context,
          text: 'Upload Tax Card',
          isUploaded: false,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: context.setWidth(8.0),
        left: context.setWidth(5.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: context.setSp(14),
        ),
      ),
    );
  }

  Widget _buildClickableField({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.setWidth(15),
          vertical: context.setWidth(15),
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(context.setWidth(15)),
          border: Border.all(color: textColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: context.setWidth(20)),
            Gap(context.setWidth(10)),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileField({
    required BuildContext context,
    required String text,
    required bool isUploaded,
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return InkWell(
      onTap: isUploaded ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.setWidth(15),
          vertical: context.setWidth(15),
        ),
        decoration: BoxDecoration(
          color: isUploaded
              ? HexColor('F5821F').withValues(alpha: 0.05)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(context.setWidth(15)),
          border: isUploaded
              ? Border.all(color: HexColor('F5821F').withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              isUploaded
                  ? Icons.check_circle_outline
                  : Icons.upload_file_outlined,
              color: isUploaded ? HexColor('F5821F') : Colors.grey,
              size: context.setWidth(20),
            ),
            Gap(context.setWidth(10)),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isUploaded ? HexColor('F5821F') : Colors.grey[600],
                  fontWeight: isUploaded ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            if (isUploaded)
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.close,
                  size: context.setWidth(18),
                  color: Colors.grey,
                ),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
          ],
        ),
      ),
    );
  }
}
