import 'package:flutter/material.dart';

import '../../auth/data/models/user_models.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, this.user});

  final UserModels? user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F5),
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 34,
              backgroundColor: Color(0xFFFF6900),
              child: Text('AH',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
          const SizedBox(height: 28),
          _field('Full Name', _nameController),
          _field('Email', _emailController,
              keyboardType: TextInputType.emailAddress),
          _field('Phone', _phoneController, keyboardType: TextInputType.phone),
          _field('Address', _addressController),
          Container(
            margin: const EdgeInsets.only(top: 4, bottom: 20),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFFD6A8)),
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFFFF7ED),
            ),
            child: const Row(
              children: [
                Icon(Icons.location_on_outlined, color: Color(0xFFFF6900)),
                SizedBox(width: 8),
                Text(
                  'Location — tap to update on map',
                  style: TextStyle(color: Color(0xFFCA3500)),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile saved successfully!')),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFF6900),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
      ),
    );
  }
}
