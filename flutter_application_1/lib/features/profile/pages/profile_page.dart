import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/routes/app_routes.dart';
import '../../auth/data/models/user_models.dart';
import '../../home/widgets/shop_bottom_navigation.dart';
import '../data/remote/profile_remote_data_source.dart';
import '../widgets/logout_button.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.authToken});

  final String? authToken;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final Future<_ProfileData> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<_ProfileData> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = widget.authToken ?? prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      throw StateError('Please login to view your profile.');
    }

    final user = await ProfileRemoteDataSource().getProfile(token: token);
    return _ProfileData(user: user, token: token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF101828),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: FutureBuilder<_ProfileData>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6900)),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person_off_outlined,
                      color: Color(0xFFFF6900),
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      snapshot.error.toString().replaceFirst('Exception: ', ''),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton(
                      onPressed: () => setState(() {
                        _profileFuture = _loadProfile();
                        Future<String?> _getToken() async {
                          final prefs = await SharedPreferences.getInstance();
                          return prefs.getString('auth_token');
                        }
                      }),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final profile = snapshot.data!;
          final user = profile.user;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _ProfileHeader(
                name: user.name ?? 'User',
                email: user.email ?? '',
                phone: user.phone ?? '',
                picture: user.pic,
              ),
              const SizedBox(height: 14),
              _ProfileMenu(
                icon: Icons.person_outline,
                title: 'Personal Information',
                onTap: () => _openEditProfile(context, profile),
              ),
              _ProfileMenu(
                icon: Icons.location_on_outlined,
                title: 'Delivery Address',
                onTap: () => _showMessage(context, 'Delivery address'),
              ),
              _ProfileMenu(
                icon: Icons.inventory_2_outlined,
                title: 'My Orders',
                onTap: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.orders),
              ),
              _ProfileMenu(
                icon: Icons.favorite_border,
                title: 'Favorites',
                onTap: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.favorites,
                ),
              ),
              _ProfileMenu(
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                onTap: () => _openEditProfile(context, profile),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: TextButton.icon(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        LogoutButton(authToken: profile.token),
                      ],
                    ),
                  ),
                  icon: const Icon(Icons.logout, color: Color(0xFFFF2D55)),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xFFFF2D55),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF1F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const ShopBottomNavigation(currentIndex: 4),
    );
  }

  void _openEditProfile(BuildContext context, _ProfileData profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(user: profile.user),
      ),
    );
  }

  void _showMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title is ready to be connected.')),
    );
  }
}

class _ProfileData {
  const _ProfileData({required this.user, required this.token});

  final UserModels user;
  final String token;
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.phone,
    this.picture,
  });

  final String name;
  final String email;
  final String phone;
  final String? picture;

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? 'U'
        : name
            .trim()
            .split(RegExp(r'\s+'))
            .take(2)
            .map((part) => part[0].toUpperCase())
            .join();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: const Color(0xFFFF6900),
            backgroundImage: picture == null || picture!.isEmpty
                ? null
                : NetworkImage(picture!),
            child: picture == null || picture!.isEmpty
                ? Text(
                    initials,
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF101828),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(email, style: const TextStyle(color: Color(0xFF667085))),
                const SizedBox(height: 3),
                Text(phone, style: const TextStyle(color: Color(0xFF98A2B3))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  const _ProfileMenu({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 61,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFF2F4F7))),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF6900), size: 21),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Color(0xFF344054)),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF98A2B3)),
          ],
        ),
      ),
    );
  }
}
