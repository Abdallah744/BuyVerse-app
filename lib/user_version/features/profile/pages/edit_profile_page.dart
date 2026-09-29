import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../auth/data/models/user_models.dart';
import '../data/remote/profile_remote_data_source.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, this.user, this.authToken});

  final UserModels? user;
  final String? authToken;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  File? _picture;
  bool _saving = false;

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
          Center(
            child: GestureDetector(
              onTap: _pickPicture,
              child: CircleAvatar(
                radius: 34,
                backgroundColor: const Color(0xFFFF6900),
                backgroundImage: _picture == null ? null : FileImage(_picture!),
                child: _picture == null
                    ? const Icon(Icons.person, color: Colors.white, size: 30)
                    : null,
              ),
            ),
          ),
          const Center(child: Text('Tap the icon to choose a profile photo')),
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
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFF6900),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: Text(_saving ? 'Saving...' : 'Save Changes'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPicture() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      setState(() => _picture = File(picked.path));
    }
  }

  Future<void> _save() async {
    final token = widget.authToken;
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login again to update profile')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ProfileRemoteDataSource().updateProfile(
        token: token,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        picture: _picture,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );
      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
